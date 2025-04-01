
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

@Builder function mySwiper(array: Array<string>,currentBreakpoint:string){
    Swiper(){
      ForEach(array,(item:string)=>{
        Image(item)
      },(item:string)=>item)
    }
    // .indicator(true) //是否显示导航点
    // .vertical(false) //垂直方向轮播
    .itemSpace(1)
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
    .displayCount(currentBreakpoint == 'sm'?1:2) //显示多个子页面
}

@Component
export struct MainPage {
  @StorageProp('currentBreakpoint') currentBreakpoint:string = 'sm'
  @State message: string = 'hahah'
  @State swiperList: string[] = ['https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801123322.jpg','https://woniumd.oss-cn-hangzhou.aliyuncs.com/web/xuchaobo/20210801123518.jpg']
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

  build() {
    Stack({alignContent: Alignment.Top}){
      Image($r('app.media.homebg')).objectFit(ImageFit.Fill).width('100%').height(210)
      Flex({ direction: FlexDirection.Column }){
        //logo 搜索模块
        this.topSearch()
        //轮播图模块
        mySwiper(this.swiperList,this.currentBreakpoint)
      }.padding({top: 15,left: 15,right: 15})
    }.width('100%').height('100%')
  }
}
