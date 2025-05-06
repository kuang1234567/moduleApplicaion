import { MainPage } from 'homelibrary'
import { MyPage} from './MyPage'
import { ProductPage } from './productPage'
import { ShopCarPage } from './shopCarPage'
import { router } from '@kit.ArkUI'

class GlobalTmp  {
  index: number
  name: string
  normalImage: Resource
  selectImage: Resource

  constructor(index: number,name: string,normalImage: Resource,selectImage: Resource,) {
    this.index = index
    this.name = name
    this.normalImage = normalImage
    this.selectImage = selectImage
  }
}

@Entry
@Component
struct Page02_commonMedia {
  //放到index页面注册
  @StorageProp('currentBreakpoint') currentBreakpoint:string = 'sm'
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#d5153f'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  //@Builder 自定义构建函数：1.可以将重复使用的UI元素抽象成一个方法，在build方法里调用.2.@Builder装饰的函数内部，不允许修改参数值，否则框架会抛出运行时错误
  //@Builder只接受一个参数，当传入一个参数的时候，通过对象字面量的形式传递，值的改变会引起UI的刷新。 传两个或两个以上会有ui不更新的情况。
  @Builder tabBuilder(objParams: GlobalTmp) {
    Column() {
      Image(this.currentIndex === objParams.index ? objParams.selectImage : objParams.normalImage).width(35).height(30).objectFit(ImageFit.Fill)
      Text(objParams.name)
        .fontColor(this.currentIndex === objParams.index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentIndex === objParams.index ? 500 : 400)
        .lineHeight(22)
    }.width('100%')
  }

  private routerPushDetail = (id:string)=>{
    console.log('idddd',id)
    router.pushUrl({
      url: 'pages/Page03_detial',
      params:{value:id}
    })
  }
  build() {
      Column(){
        Tabs({ barPosition: BarPosition.End, index: this.currentIndex, controller: this.controller }) {
          TabContent() {
            MainPage({onClickItem: this.routerPushDetail})
          }.tabBar(this.tabBuilder(new GlobalTmp(0, '首页',$r('app.media.home'),$r('app.media.homeActive'))))

          TabContent() {
            ProductPage()
          }.tabBar(this.tabBuilder(new GlobalTmp(1, '产品' ,$r('app.media.product'),$r('app.media.productActive'))))

          TabContent() {
            ShopCarPage()
          }.tabBar(this.tabBuilder(new GlobalTmp(2, '购物车' ,$r('app.media.shopcar'),$r('app.media.shopcarActive'))))

          TabContent() {
            MyPage()
          }.tabBar(this.tabBuilder(new GlobalTmp(3, '我的' ,$r('app.media.my'),$r('app.media.myActive'))))
        }
        .vertical(this.currentBreakpoint === 'lg')  //是否为侧边导航栏 平板的或者折叠屏的时候为侧边导航
        .barMode(BarMode.Fixed)
        .barWidth(this.currentBreakpoint === 'lg'? 80 : null ) //tab的宽度不设置的话就平分
        // .barHeight(80)
        .animationDuration(400)
        .onChange((index: number) => {
          // currentIndex控制TabContent显示页签
          this.currentIndex = index
          // this.controller.changeIndex(index) //新版不写也可以
        })
        //使用自定义页签时，在onChange事件中联动可能会导致滑动页面切换后才执行页签联动，引起自定义页签切换效果延迟。建议在onAnimationStart中监听并刷新当前索引，以确保动效能够及时触发。
        .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
          if (index === targetIndex) {
            return
          }
          // selectedIndex控制自定义TabBar内Image和Text颜色切换
          setTimeout(()=>{
            this.currentIndex = targetIndex
          },300)
        })
        // .width(360) //width 和 height 不设置的话默认充满屏幕
        // .height(296)
      }.width('100%').height('100%')
  }
}