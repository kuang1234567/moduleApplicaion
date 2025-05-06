import { myRequestGet } from 'common'


//商品详情接口
export function findProductDataByIdApi<T,K>(params:K){
  console.log('params1',JSON.stringify(params))
  return myRequestGet<T,K>('/goods/searchById',params)
}