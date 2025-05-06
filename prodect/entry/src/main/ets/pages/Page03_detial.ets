//跨包之间的跳转
//Home页面默认是放在features中的。我们现在需要从feature包模块中跳转页面到主模块中的页面。会采用几种跳转方式来实现
//路由跳转
//如果默认用pushUrl这种方式来进行路由跳转，默认只能跳转本模块中页面。
//但是如果采用pushNamedRoute，路由动态名字来跳转。可以实现跨包跳转。
import { swiperDataModel } from 'homelibrary/src/main/ets/viewModel/homeModel'
import { router } from '@kit.ArkUI';
import { paramsType } from '../viewModel/routerParamsModel';
import {findProductDataByIdApi} from '../apis/index'
import { goodsModel } from '../viewModel/goodsModel';
import { objectToQueryString,cartDBUtils } from 'common'
import { relationalStore } from '@kit.ArkData';

//（1）给你要跳转的模块设置路由名字     （2）子包引入主包页面：默认采用相对路径 // import
// '../../../../../../prodect/entry/src/main/ets/pages/Page03_detial' 但这种方式已经废弃，相对路劲引用运行会报错
//子包引入子包页面   import '@ohos/library/src/main/ets/pages/Index'; // 引入共享包中的命名路由页面 ，需要在oh-package.json5中配置


@Extend(Text)
  function TopIconStyle(){
    .width(40).height(40).backgroundColor('rgba(16, 24, 7,0.4)')
  .borderRadius('50%').fontColor(Color.White).textAlign(TextAlign.Center)
  }

@Entry({routeName: 'detail'})
@Component
struct Page03_detial {

  @State swiperList: string[] = []
  @State detailInfo:goodsModel = new goodsModel()

  @Styles pieceStyle(){
    .backgroundColor(Color.White).borderRadius(10).padding(15).margin({bottom: 10})
  }

  aboutToAppear(): void {
    let params = router.getParams()
    let obj = params as paramsType<string>
    let queryUrl =  objectToQueryString({'id':obj.value})
    this.findProductDataById(queryUrl)
  }

  /**
   *  获取商品详情
   */
  findProductDataById = async (params:string)=>{
    let res = await findProductDataByIdApi<goodsModel,string>(params)
    this.detailInfo = res.message
    console.log('detailInfo',JSON.stringify(this.detailInfo))
 }

  aboutToDisappear(): void {

  }

  //底部小导航图标文字封装
  @Builder ImageAndTextList(imageUrl: Resource,text:string){
    Column(){
      Image(imageUrl).width(34)
      Text(text).fontSize(16).margin({top: 2})
    }.height('100%').justifyContent(FlexAlign.Center).onClick(()=>{
      switch (text) {
        case '首页':
            router.pushUrl({
              url: 'pages/Page02_commonMedia'
            })
          break;
        case '购物车':
          router.pushUrl({
            url: 'pages/shopCarPage'
          })
          break;
        default:
          break;
      }
    })
  }

  //底部导航
  @Builder bottomMenu(){
    GridRow({columns: { sm: 6, md: 8 }}){
      GridCol({span:{sm: 1, md: 1}}){
        this.ImageAndTextList($r('app.media.ic_home'),'首页')
      }
      GridCol({span:{sm: 1, md: 1}}){
        this.ImageAndTextList($r('app.media.ic_shopping_cart'),'购物车')
      }
      GridCol({span:{sm: 4, md: 6}}){
        Flex({justifyContent: FlexAlign.Center,alignItems:ItemAlign.Center}){
          Column(){
            Text('加入购物车').fontSize(16).fontColor(Color.White)
          }.width('50%').height('80%').backgroundColor('#e5935b').borderRadius({
            topLeft: 10,
            bottomLeft: 10,
          }).justifyContent(FlexAlign.Center) // 分别设置每个角的圆角半径
          .onClick(()=>{

            //构造relationalStore.ValuesBucket数据用于添加到创建的关系数据库中
            //ID可以自生成可以不用加
            const valueBucket1: relationalStore.ValuesBucket = {
              'GOODS_NAME': this.detailInfo.goods_name,
              'GOODS_BIG_LOGO': this.detailInfo.goods_big_logo,
              'GOODS_CODE': this.detailInfo.goods_id,
              'GOODS_PRICE': Number(this.detailInfo.goods_price),
              'GOODS_COUNT': 1,
              'GOODS_CHECKED': 0,
            };
            cartDBUtils.insertDataDB('MYCART',valueBucket1)
          })
          Column(){
            Text('立即购买').fontSize(16).fontColor(Color.White).onClick(()=>{
              router.pushUrl({
                url: 'pages/cartDBPage'
              })
            })
          }.width('50%').height('80%').backgroundColor('#ee4434').borderRadius({
            topRight: 10,
            bottomRight: 10,
          }).justifyContent(FlexAlign.Center)
        }.height('100%')
      }
    }.width('100%').height(60).padding({left: 5,right:10}).backgroundColor('#f1f0f5')
  }

  @Builder detailSwiper(){
    Stack({alignContent:Alignment.BottomEnd}){
      Swiper(){
        ForEach(this.detailInfo.goods_small_logo,(item:string,index)=>{
          Image(item).objectFit(ImageFit.Contain)
        },(item:string)=>item)
      }.indicator(false).autoPlay(true).loop(true)
      Text(`${1}/${3}`).fontSize(16).fontColor(Color.White).borderRadius(40).backgroundColor('rgba(16, 24, 7,0.4)')
        .padding({top: 5,left: 15,right: 15,bottom: 5}).margin({ bottom: 10, right: 20 }).zIndex(2)
    }.height(334).backgroundColor(Color.White)
  }

  @Builder goodsDescribe (){
      Column(){
        Text(`￥${1899}`).fontColor('#713f48').fontSize(18)
        Text('安吉拉就打开拉萨打开撒旦克里夫及爱上的链接发快速了解阿联军的书法家阿喀琉斯拉萨大家埃弗拉快速了解阿联军的书法家阿喀琉斯拉萨大家埃弗拉')
          .fontWeight(FontWeight.Bold)
          .maxLines(2).textOverflow({
            overflow: TextOverflow.Ellipsis
        }).ellipsisMode(EllipsisMode.END)
      }.alignItems(HorizontalAlign.Start).pieceStyle()
  }
  @Builder chooseTypeBar(){
      Flex(){
        Text('已选').fontWeight(FontWeight.Bold).margin({left: 10})
        Text(`深蓝色8*128G*1`)
      }.pieceStyle()
  }

  @Builder serviceBar(){
    Column(){
    }.width('100%').height(200).pieceStyle()
  }

  @Builder UserEvaluate(){
    Column(){
    }.width('100%').height(200).pieceStyle()
  }

  build() {
    Stack({alignContent: Alignment.TopStart}){
      //商品详情模块
      Flex({direction: FlexDirection.Column}){
        Scroll(){
          GridRow({columns:{sm:4,md:8,lg:12},gutter:12}){
            GridCol({span:{sm:4,md:8,lg:5}}){
              //轮播图模块
              this.detailSwiper()
            }
            GridCol({span:{sm:4,md:8,lg:7}}){
              Column(){
                //商品介绍
                this.goodsDescribe()
                //规则模块
                this.chooseTypeBar()
                //服务模块
                this.serviceBar()
                //评论模块
                this.UserEvaluate()
                //商品展示图
              }
            }.padding(8)
          }
        }.align(Alignment.Top)//滚动内容的对齐方式
        .backgroundColor('#f1f0f5').width('100%').flexGrow(1)
        //底部导航模块
        this.bottomMenu()
      }
      //返回分享模块
      Flex({justifyContent: FlexAlign.SpaceBetween}){
        Text() {
          SymbolSpan($r('sys.symbol.arrow_left'))
            .fontSize(30)
        }.TopIconStyle()
        Text() {
          SymbolSpan($r('sys.symbol.arrow_right_up_and_square'))
            .fontSize(30)
        }.TopIconStyle()
      }.padding(10).zIndex(2)
    }
  }
}

//回调函数的方式显示子包跳转页面
//在主包重引入了MainPage页面相当于主包加载了子组件，完全可以采用父子组件传递参数的方式来执行通信。
//(1)先在主包页面中定义跳转函数
// private routerPushDetail = (id:string)=>{
//   console.log('idddd',id)
//   router.pushUrl({
//     url: 'pages/Page03_detial',
//     params:{value:id}
//   })
// }
//(2)通过组件传参的方式将跳转函数传到子页面中
//MainPage({onClickItem: this.routerPushDetail})
//(3)在子包页面中接收,并调用即可实现子包跳转主包页面

//url的方式跳转   (com.jnks.moduleApplication这个项目的bundleName,在AppScope文件中的app.json5文件可以看到)
// .onClick(() => {
//   router.pushUrl(({
//     url: 'com.jnks.moduleApplication/homeLibrary/ets/pages/MainPage'
//   })
// })
//pushUrl默认只能找本包的页面,以及在路由列表中注册了这个页面的.
//限制: 1.这种方式只能主包页面跳转到子包页面.不能反过来
//2.一般默认跳转只能是@entry修饰页面