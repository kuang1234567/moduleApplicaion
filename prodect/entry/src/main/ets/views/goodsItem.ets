//@Watch的使用
//@Watch 可以指定实现监听页面的某一个属性。当这个值发生变化，默认会执行一段函数。
//使用限制：1.@Watch监控状态变量。进来不要出现循环引用对象或者变量
//2.不要在@Watch的监听函数中执行复杂耗时的业务，引起性能问题
//3.不建议在@Watch监听函数中使用await和async
//4.@Watch只能一个对象的改变，不能和vue一样具体到哪个值。并且不能获取到之前的值和改变的值。在状态管理V2中提供了@Monitor来弥补@Watch的缺陷。
//规则
//@Watch监控属性回调函数必须是普通函数。不能是箭头函数
//@Watch有立即监听的效果

import { CartModel } from "common/src/main/ets/comonModel/cartModel";
import { cartDBUtils } from 'common'
import { relationalStore } from "@kit.ArkData";

@Component
export struct GoodsItem {
  @ObjectLink @Watch("show") item:CartModel

  show(key:string){
    console.log(`item变化:${key}`)
    this.onClickItem()
  }
  //夫组件传过来的计算总价
  private onClickItem = ()=>{}

  aboutToAppear(): void {
  }
  build() {
    Flex({direction: FlexDirection.Row,alignItems:ItemAlign.Center }){
      Column(){
        Checkbox({ name: `${this.item.id}`, group: 'checkboxGroup' })
          .selectedColor('#d26726')
          .shape(CheckBoxShape.CIRCLE)
          .select(this.item.goods_checked!=0?true:false)
          .onChange((value: boolean) => {
            if(value){
              this.item.goods_checked = 1
            }else{
              this.item.goods_checked = 0
            }
          })
      }.width('10%')
      Image(this.item.goods_big_logo).objectFit(ImageFit.Fill).width('35%')
      Column({space: 5}){
        Text(this.item.goods_name)
          .maxLines(2)
          .textOverflow({
          overflow: TextOverflow.Ellipsis
        }).ellipsisMode(EllipsisMode.END)
        Text(`￥1299`).fontColor('#835157')
        Row(){
          Image(this.item.goods_count == 1?$r('app.media.ic_decrease_disable'):$r('app.media.ic_decrease')).width(20).height(20)
            .onClick(()=>{
              if(this.item.goods_count == 1){
                return
              }else{
                (this.item.goods_count as number) -= 1
                //更新数据库中的数据
                const updateColum: relationalStore.ValuesBucket = {
                  GOODS_COUNT: this.item.goods_count as number
                }
                cartDBUtils.updateById("MYCART",Number(this.item.id),updateColum)
              }

            })
          Text(`${this.item.goods_count}`).margin({left: 5 ,right: 5})
          Image($r('app.media.ic_increase')).width(20).height(20).onClick(()=>{
              (this.item.goods_count as number) += 1
            //更新数据库中的数据
            const updateColum: relationalStore.ValuesBucket = {
              GOODS_COUNT: this.item.goods_count as number
            }
            cartDBUtils.updateById("MYCART",Number(this.item.id),updateColum)
          })
        }
      }.width('55%')
    }.width('100%').height(120).backgroundColor(Color.White).borderRadius(10)
  }
}