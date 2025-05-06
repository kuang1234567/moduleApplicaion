import { CartModel } from "common/src/main/ets/comonModel/cartModel";
import { GoodsItem } from "../views/goodsItem";
import { cartDBUtils } from 'common'

@Entry
@Component
export struct ShopCarPage {
  @State carts:CartModel[] = []
  @State totalPrice: number = 0

  //底部结算
  @Builder bottomAccount (){
    Flex({justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}){
      Row(){
        CheckboxGroup({ group: 'checkboxGroup' }).checkboxShape(CheckBoxShape.CIRCLE).selectedColor('#d26726').onChange((itemName: CheckboxGroupResult) => {
          console.info("checkbox group content" + JSON.stringify(itemName));
        })
        Text('全选').fontSize(14).fontColor('#a9a9a9')
      }
      Row(){
        Text(`总价`).fontWeight(FontWeight.Bold)
        Text(`￥${this.totalPrice}`).fontColor('#e62743').margin({left: 10,right:10})
        Button(){
          Text('结算').fontSize(16).fontColor(Color.White)
        }.width(100).height(30).backgroundColor('#e62743').onClick(() => {
          console.log('ButtonType.Normal')
        })
      }
    }.backgroundColor(Color.White).padding(5)
  }

  @Builder itemEnd(item:CartModel) {
    Row() {
      Button("Delete").backgroundColor(Color.Red).margin("4vp").onClick(()=>{
          animateTo({ duration: 500 }, () => {
            item.goods_checked = 0 //为了更新全选框的状态
            let index = this.carts.indexOf(item)
            this.carts.splice(index, 1)
            this.computedTotalPrice()
            cartDBUtils.deleteById("MYCART", (item.id as string))
          })
      })
    }.padding("4vp").justifyContent(FlexAlign.SpaceEvenly)
  }

  fetchDBData = async () => {
    const res = await cartDBUtils.queryDataDB(
      ["ID", "GOODS_NAME", "GOODS_BIG_LOGO", "GOODS_PRICE", "GOODS_CODE", "GOODS_COUNT", "GOODS_CHECKED"],
      "MYCART"
    )
    this.carts = res
  }

  aboutToAppear(): void {
    // const cart01 = new CartModel()
    // cart01.id = "1"
    // cart01.goods_name = "创维（Skyworth）42X6创维（Skyworth）42X6创维（Skyworth）42X6创维（Skyworth）42X6创维（Skyworth）42X6"
    // cart01.goods_big_logo = "http://image2.suning.cn/uimg/b2c/newcatentries/0070078057-000000000634917020_1_800x800.jpg"
    // cart01.goods_code = "001"
    // cart01.goods_price = 1299
    // cart01.goods_count = 1
    // cart01.goods_checked = 0
    // this.carts.push(cart01)
    // const cart02 = new CartModel()
    // cart02.id = "2"
    // cart02.goods_name = "华为平板"
    // cart02.goods_big_logo = "http://image2.suning.cn/uimg/b2c/newcatentries/0070078057-000000000634917020_1_800x800.jpg"
    // cart02.goods_code = "001"
    // cart02.goods_price = 1299
    // cart02.goods_count = 1
    // cart02.goods_checked = 0
    // this.carts.push(cart02)
    this.fetchDBData()
  }

  //计算总价  //传给子组件的函数必须写成箭头函数不然在子组件this会改变
  computedTotalPrice = ()=>{
    const result = this.carts.reduce((sum:number,item:CartModel)=>{
      if(item.goods_checked == 1){
        sum += ((item.goods_count as number) * (item.goods_price as number))
      }
      return sum
    },0)
    this.totalPrice = result
  }

  build() {
    Column(){
      Flex({direction:FlexDirection.Column,justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}){
        //标题
        Text('购物车').fontSize(26).margin({top:5,bottom:10})
        //列表
        List({ space: 10, initialIndex: 0 }){
          ForEach(this.carts,(item:CartModel)=>{
            ListItem(){
              GoodsItem({item:item, onClickItem:this.computedTotalPrice})
            }.swipeAction({
              end: {
                builder: () => { this.itemEnd(item) },
                // onAction: () => { //组件进入长距删除区后删除ListItem时调用，进入长距删除区后抬手时触发。
                //   animateTo({ duration: 1000 }, () => {
                //     let index = this.carts.indexOf(item)
                //     this.carts.splice(index, 1)
                //   })
                // },
                actionAreaDistance: 56, //设置组件长距离滑动删除距离阈值
                // onEnterActionArea: () => {  //在滑动条目进入删除区域时调用，只触发一次，当再次进入时仍触发。
                //   // this.enterEndDeleteAreaString = "enterEndDeleteArea"
                //   // this.exitEndDeleteAreaString = "not exitEndDeleteArea"
                //   console.log('进入删除区域时调用')
                // },
                // onExitActionArea: () => { //当滑动条目退出删除区域时调用，只触发一次，当再次退出时仍触发。
                //   // this.enterEndDeleteAreaString = "not enterEndDeleteArea"
                //   // this.exitEndDeleteAreaString = "exitEndDeleteArea"
                //   console.log('退出删除区域时调用')
                // }
              }
            })
          },(item:CartModel)=>item.id)
        }.scrollBar(BarState.Off) //滚动条显隐
        .friction(0.6) //滚动摩擦系数
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .flexGrow(1)
        .padding({left: 10,right:10})
        //底部结算
        this.bottomAccount()
      }.height('100%')
    }.width('100%').height('100%').backgroundColor('#eef0f2')
  }
}