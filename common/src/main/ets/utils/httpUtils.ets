//鸿蒙网络请求
//1.基本概念：http模块是鸿蒙内置的一个模块，提供了网络请求能力。
//开发流程：
//1.首先确保在entry中src/module.json5中开通了网络请求权限
// "requestPermissions": [
//       {
//         "name" : "ohos.permission.INTERNET",
//       }
//     ],
//2.从@kit.NetWorkKit中导入http命名空间
//3.调用createHttp，创建一个HttpREquest对象
//4.调用该对象的on()方法，订阅http响应头事件，此接口会比request请求先返回。可以更具业务需要订阅此消息。（不是必须，监控响应头信息）
//5.调用该对象的request（）方法，传入http请求的url地址和可选参数，发起网络请求。
//6.按照实际业务需要，解析返回结果。
//7.调用该对象的off()方法，取消订阅http响应头事件。（不是必须，根据业务自己决定）
//8.当该请求使用完毕是，调用destroy（）方法主动注销


import {http} from '@kit.NetworkKit'
import { configObj } from '../constants/basicConstants'

/**
 * 封装公共的请求代码
 * @param url
 * @param method
 * @param requestData {"id"："value"}
 *
 */


export function MyRequest<T,K> (url:string,method:http.RequestMethod,requestData?:K) {
  console.log('requestData',JSON.stringify(requestData))
  // 每一个httpRequest对应一个HTTP请求任务，不可复用。
  let httpRequest = http.createHttp();
  // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息。（不是必须的）
  httpRequest.on('headersReceive', (header: Object) => {
    console.info('header: ' + JSON.stringify(header));
  });

  // 将 requestData 转换为查询参数
  let requestUrl =''
  //当为GET请求时，携带参数的话手动拼接，extraData传递Json后端解析不出来
  if(requestData&& method === http.RequestMethod.GET){
    requestUrl = configObj.BASE_URL + url + requestData
  }else{
    requestUrl = configObj.BASE_URL + url
  }

  //通过Promise来实现网络请求结果储Promise容器中
  return new Promise((resolve:(value:Record<string,T>)=>void,reject:(value?:string)=>void)=>{
    //request请求异步代码cc
    httpRequest.request(requestUrl,{
      method:method,//请求方式
      header:{ //设置请求头
        //这个是前端浏览器告诉后端，前端传递的数据格式
        // 开发者根据自身业务需要添加header字段。
        "Content-type":"application/json"
      },
      extraData: JSON.stringify(requestData) || '',
      // expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
      // usingCache: true, // 可选，默认为true
      connectTimeout: 6000,
      readTimeout: 6000
    },(error:Error,data:http.HttpResponse)=>{
      //没有error代表成功
      if(!error){
        console.log(`成功的结果${JSON.stringify(data)}`)
        console.log('成功',data.result)
        resolve(JSON.parse(data.result as string))
        // 取消订阅HTTP响应头事件。
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，开发者务必调用destroy方法主动销毁该JavaScript Object。
        httpRequest.destroy();
      }else{
        console.log(`失败的结果${JSON.stringify(error)}`)
        reject(error.message)
        // 取消订阅HTTP响应头事件。
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，开发者务必调用destroy方法主动销毁该JavaScript Object。
        httpRequest.destroy();
      }
    })
  })
}

//针对get post put delete请求封装一次
//定义一个函数，函数返回结果promise ，而promise结果
export function myRequestGet<T,K>(url:string,requestData?:K):Promise<Record<string,T>>{
  console.log('requestData',JSON.stringify(requestData))
  return MyRequest<T,K>(url,http.RequestMethod.GET,requestData)
}

export function myRequestPost<T,K>(url:string,requestData?:K):Promise<Record<string,T>>{
  return MyRequest<T,K>(url,http.RequestMethod.POST,requestData)
}

export function myRequestPut<T,K>(url:string,requestData?:K):Promise<Record<string,T>>{
  return MyRequest<T,K>(url,http.RequestMethod.PUT,requestData)
}

export function myRequestDelete<T,K>(url:string,requestData?:K):Promise<Record<string,T>>{
  return MyRequest<T,K>(url,http.RequestMethod.DELETE,requestData)
}
