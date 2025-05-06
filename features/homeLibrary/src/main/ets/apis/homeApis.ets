/**
 *  封装页面需要的各种请求
 */
import { myRequestGet } from 'common'
import { http } from '@kit.NetworkKit'


//获取轮播图
export function findSwiperDataApi<T,K>(){
  return myRequestGet<T,K>('/home/swiperdata')
}

//获取分类信息
export function findCategoryDataApi<T,K>(){
  return myRequestGet<T,K>('/home/catitems')
}

//获取商品列表
export function findProductDataApi<T,K>(){
  return myRequestGet<T,K>('/goods/search')
}

export function findProductDataByIdApi<T,K>(params:K){
  return myRequestGet<T,K>('/goods/searchById',params)
}
