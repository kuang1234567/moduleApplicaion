export  class goodsModel {
  "_id"= ""
  "add_time"= ""
  "cat_id"= ""
  "cat_one_id"= ""
  "cat_three_id"= ""
  "cat_two_id"= ""
  "goods_big_logo"= ""
  "goods_id"= ""
  "goods_name"= ""
  "goods_number"= ""
  "goods_price"= ""
  "goods_small_logo":Array<string> = []
  "goods_weight"= ""
  "hot_mumber"= ""
  "is_promote"= ""
  "upd_time"= ""
  "evaluate":Array<evaluateModel> = []
}

export class evaluateModel {
  "userId"= ""
  "userIcon"= ""
  "userNumber"= ""
  "rating"= 0
  "desc"= ""
}