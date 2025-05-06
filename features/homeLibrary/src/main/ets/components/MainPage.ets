
//全局的定义写法
// @Builder function  topSearch(){
//   Column(){
//     Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween,alignItems: ItemAlign.Center }){
//       Image($r('app.media.woniuicon')).width(30)
//       Image($r('app.media.ic_scan')).width(30)
//     }.width('100%')
//     Row(){
//       Image($r('app.media.ic_search')).width(25).margin({left: 15})
//     }.width('100%').height(40).backgroundColor(Color.White).borderRadius('50%').margin({top: 15})
//   }.padding({top: 15,left: 15,right: 15})  }
import { goodsDataModel, NavModel, swiperDataModel } from "homelibrary/src/main/ets/viewModel/homeModel"
import { MyRequest } from 'common'
import { http } from '@kit.NetworkKit'
import {findCategoryDataApi, findProductDataApi, findSwiperDataApi} from '../apis/homeApis'
import { router } from "@kit.ArkUI"
//这种子包跳转到主包页面的方式废弃，不能用相对路径来导入页面
// import '../../../../../../prodect/entry/src/main/ets/pages/Page03_detial'

class SwiperParameter {
  swiperList:Array<swiperDataModel> = []
  currentBreakpoint:string = ''
}

@Builder function mySwiper($$:SwiperParameter){
    Swiper(){
      ForEach($$.swiperList,(item:swiperDataModel)=>{
        Image(item.image_src)
      },(item:swiperDataModel)=>item._id)
    }
    // .indicator(true) //是否显示导航点
    // .vertical(false) //垂直方向轮播
    .itemSpace(1) //轮播之间的间距
    .width('100%')
    .margin({top: 15})
    .autoPlay(true) //自动轮播
    .loop(true) //循环播放
    .borderRadius(16)
    .indicator(
      Indicator.dot()
        // .left(0)
        .itemWidth(15)
        .itemHeight(15)
        .selectedItemWidth(30)
        .selectedItemHeight(15)
        .color(Color.Red)
        .selectedColor(Color.Blue)
    )
    .displayCount($$.currentBreakpoint == 'sm'?1:2) //显示多个子页面
}

@Component
export struct MainPage {
  @StorageProp('currentBreakpoint') currentBreakpoint:string = 'sm'
  private  scroller: Scroller = new Scroller();
  private scrollerForList: Scroller = new Scroller()
  @State listPosition: number = 0; // 0代表滚动到List顶部，1代表中间值，2代表滚动到List底部。
  @State swiperList: swiperDataModel[] = [
    {
      _id:'1',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801123322.jpg',
      goods_id:'1',
      navigator_url:'',
      open_type:'switchTab'
    },
   {
     _id:'2',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801123518.jpg',
      goods_id:'1',
      navigator_url:'',
      open_type:'switchTab'
   }
  ]
  @State navList:NavModel[] = [
    {
      _id:'1',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801152611.png',
      name:'旅游日记',
      navigator_url:'',
      open_type:'switchTab'
    },
    {
      _id:'2',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801152611.png',
      name:'旅游日记',
      navigator_url:'',
      open_type:'switchTab'
    },
    {
      _id:'3',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801152611.png',
      name:'旅游日记',
      navigator_url:'',
      open_type:'switchTab'
    },
    {
      _id:'4',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801152611.png',
      name:'旅游日记',
      navigator_url:'',
      open_type:'switchTab'
    },
    {
      _id:'5',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801152611.png',
      name:'旅游日记',
      navigator_url:'',
      open_type:'switchTab'
    },
    {
      _id:'6',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801152611.png',
      name:'旅游日记',
      navigator_url:'',
      open_type:'switchTab'
    },
    {
      _id:'7',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801152611.png',
      name:'旅游日记',
      navigator_url:'',
      open_type:'switchTab'
    },
    {
      _id:'8',
      image_src:'https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801152611.png',
      name:'旅游日记',
      navigator_url:'',
      open_type:'switchTab'
    }
  ]
  @State goodsData: goodsDataModel[] = [
    // {
    //   _id: "60e088dc65150000ab002c3d",
    //   add_time: "1516663280",
    //   cat_id: "9",
    //   cat_one_id: "1",
    //   cat_three_id: "9",
    //   cat_two_id: "3",
    //   goods_big_logo: "http://image2.suning.cn/uimg/b2c/newcatentries/0070078057-000000000634917020_1_800x800.jpg",
    //   goods_id: "57443",
    //   goods_name: "创维",
    //   goods_number: "100",
    //   goods_price: "4999",
    //   goods_small_logo: "http://image2.suning.cn/uimg/b2c/newcatentries/0070078057-000000000634917020_1_400x400.jpg",
    //   goods_weight: "100",
    //   hot_mumber: "0",
    //   is_promote: "false",
    //   upd_time: "1516663280"
    // },
    // {
    //   _id: "60e0895f65150000ab002c3e",
    //   add_time: "1516663280",
    //   cat_id: "9",
    //   cat_one_id: "1",
    //   cat_three_id: "9",
    //   cat_two_id: "3",
    //   goods_big_logo: "http://image2.suning.cn/uimg/b2c/newcatentries/0070078057-000000000634917020_1_800x800.jpg",
    //   goods_id: "57444",
    //   goods_name: "创维（Skyworth）42X6 42英寸10核智能酷开网络平板液晶电视（黄色）",
    //   goods_number: "100",
    //   goods_price: "1899",
    //   goods_small_logo: "http://image2.suning.cn/uimg/b2c/newcatentries/0070078057-000000000634917020_1_400x400.jpg",
    //   goods_weight: "100",
    //   hot_mumber: "0",
    //   is_promote: "false",
    //   upd_time: "1516663280"
    // }
  ]

  //接受外部函数 当外部传参过来时，onClickItem这个初始的函数就会被覆盖
  private onClickItem = (id:string)=>{}
  //@Builder装饰器
  //作用： 将页面中需要提取出来的布局代码，封装为一个函数。然后再重复利用。
  //范围： 只针对当前这个组件，如果要针对多个组件，单独创建组件文件（写成全局的）
  //不支持引入的方式
  //传递参数
  //通过@Builder装饰器来实现函数的定义。可以给函数传递参数
  //参数传递有两种类型：在js中只有值传递的概念
  //值传递：将一个结果传递给函数，函数直接拿来使用。当这个结果发生改变不影响函数内部渲染。
  // @Builder passByValue (value:string){
  //   Text(value)
  // }  //如果在组件内部把value的值改变了并不会导致passByValue ui的更新。
  //引用传递： 传递过的内存中数据的指针。一旦数据发生改变，原数据也会受到影响。 传递的必须是一个对象
  //   class ParamObj {
  //    message:string = ''
  // }
  // @Builder passByValue ($$:ParamObj){
  //   Text($$.message)
  // }
  @Builder topSearch(){
    Column(){
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween,alignItems: ItemAlign.Center }){
        Image($r('app.media.woniuicon')).width(30)
        Image($r('app.media.ic_scan')).width(30)
      }.width('100%')
      Row(){
        Image($r('app.media.ic_search')).width(25).margin({left: 15})
      }.width('100%').height(40).backgroundColor(Color.White).borderRadius('50%').margin({top: 15})
    }
  }

  //网格导航模块
  @Builder myNav(){
      Grid(){
        ForEach(this.navList,(item:NavModel)=>{
          GridItem(){
            Column(){
              Image(item.image_src).width(75)
              Text(item.name)
            }.height('100%')
          }
        },(item:NavModel)=>item._id)
      }.height(180).columnsTemplate('1fr 1fr 1fr 1fr').rowsTemplate('1fr 1fr').columnsGap(10).rowsGap(10)
      .margin({top:10}).backgroundColor(Color.White).borderRadius(10)
  }

  @Builder goodsLis(){
    List({space:10,scroller: this.scrollerForList}){
      ForEach(this.goodsData,(item:goodsDataModel)=>{
        ListItem(){
          Column(){
            Image(item.goods_small_logo).width('100%')
            Text(item.goods_name)
              .width('100%')
              .height(80)
              .baselineOffset(60) //设置文本基线的偏移量，设置该值为百分比时，按默认值显示 让文字少时纵向不居中展示
              .maxLines(4) // 设置最大显示行数
              .textOverflow({
                overflow: TextOverflow.Ellipsis // 设置超出部分显示省略号
              })
              .ellipsisMode(EllipsisMode.END) // 设置省略号的位置为末尾
            Row(){
              Text(`￥${item.goods_price}`).fontColor('#ad6357')
              Image($r('app.media.car')).width(30)
            }.width('100%').justifyContent(FlexAlign.SpaceBetween).margin({top:10})
          }.padding(5)
        }.width('100%').height(300).backgroundColor(Color.White).borderRadius(10).onClick(()=>{
          // console.log('kkkk',1)
          // router.pushNamedRoute({name: 'detail'})  //命名路由跳转方式，主包跳转子包时可以调用
          this.onClickItem(item._id)
        })
      },(item:goodsDataModel)=>item._id)
    }.lanes(2,10).height(515).scrollBar(BarState.Off).margin({top: 10,bottom:20})
    .onReachStart(() => {
      this.listPosition = 0
    })
    .onReachEnd(() => {
      this.listPosition = 2
    })
    .onScrollFrameBegin((offset: number) => {
      if ((this.listPosition == 0 && offset <= 0) || (this.listPosition == 2 && offset >= 0)) {
        this.scroller.scrollBy(0, offset)
        return { offsetRemain: 0 }
      }
      this.listPosition = 1
      return { offsetRemain: offset };
    })
  }


  aboutToAppear(): void {
    this.findSwiperData()
    this.findCategoryData()
    this.findProductData()
  }

  //获取轮播图数据
  findSwiperData = async ()=>{
    let res = await findSwiperDataApi<Array<swiperDataModel>,null>()
    this.swiperList = res.message
  }

  //获取楼层导航数据
  findCategoryData = async ()=>{
    let res = await findCategoryDataApi<Array<NavModel>,null>()
    this.navList = res.message
  }

  //获取商品数据
  findProductData = async ()=>{
    let res = await findProductDataApi<Array<goodsDataModel>,null>()
    console.log('resgg',JSON.stringify(res.message))
    this.goodsData = res.message
  }



  build() {
    Stack({alignContent: Alignment.Top}){
      Image($r('app.media.homebg')).objectFit(ImageFit.Fill).width('100%').height(210)
      // Flex({ direction: FlexDirection.Column }){
     Scroll(this.scroller){
       Column(){
         //logo 搜索模块
         this.topSearch()
         //轮播图模块
         mySwiper({swiperList:this.swiperList,currentBreakpoint:this.currentBreakpoint})
         //网格导航模块
         this.myNav()
         //商品列表模块
         // Column(){   //添加可以实现占用剩余空间，让商品列表再剩余空间滚动
         this.goodsLis()
         // }.layoutWeight(1).margin({top:10})
       }.padding({top: 15,left: 15,right: 15})
     }.onScrollFrameBegin((offset: number, state: ScrollState) => {
       //控制在滚动到网格导航模块时不再滚动
       if (offset > 0) { // 当页面上滑
         if (this.scroller.currentOffset().yOffset >= 230) { // 检测是否滚动到顶部
           this.scroller.scrollBy(0, 0); // 停止滚动
           return { offsetRemain: 0 }; // 返回剩余偏移量为 0
         }
       }
       return { offsetRemain: offset }; // 否则，继续滚动
     })
    }.width('100%').height('100%').backgroundColor('#efefef')
  }
}
