//项目应用模块
//（1）多Module设计机制
//  支持模块化开发：可以将一个庞大的项目拆分为很多个模块，每个模块负责自己的独立业务。有利于分工协作，有利于项目功能划分和维护。每个模块还可以独立编译，运行。
//他是鸿蒙系统提供的一种架构。按照指定模式来设级就能满足我们的项目设计要求。
//  支持多设备适配：每个模块独立开发，并且每个模块都可以设置支持的设备类型。应用开发完成后上架应用市场。根据你的module支持设备类型动态的进行分配。比如pad打开应用
//应用看到的是pad支持的软件或者指定的一些模块打包后应用

//鸿蒙系统打造的是 1+8+n 1是手机 8是pad，车机等 n是智能家具等更多的终端。开发的软件可能会放在各种设备上面运行。

//Module的类型
// Ability：这种模块是可以独立编译，打包，运行。相当于一个公司的子公司。独立运行，也可以和总公司一起运行。对应到程序：电商项目主模块，物流信息：可以设计子模块，这个
//模块在手机和其他业务一起运行。也可以独立放在车技，手臂奥上面运行。
//Library：实现代码的资源共享。一个大的项目我蒙可以拆分业务，放在每个模块中运行。这些模块中运行。这些模块无法独立打包出来运行，必须依赖整个项目。帮助我们分工协作，也可以帮助项目业务拆分后维护。一个模块类似与一个独立项目。
//项目中用到的公共工具或者代码。没有提取工具或者代码。每个模块重复写。

//模块的区别
//HAP：这种模块创建出来，可以代表独立的一个项目。这个模块打包后的后缀名为hap，可以独立运行到设备。也能独立上应用商店。 （鼠标移到整个项目文件夹右键
// 选择新建》选择模块》选择Empty Ability》module type为feature的创建 ） 项目 中只允许一个entry模块，可以有多个feature模块。之后可以把地图，
//支付相关的一些功能独立出去放在这个模块中，多个模块之间进行通信。

//HSP：这个模块type类型为shared，打包过后的包名hsp格式。无法独立编译和运行，必须依赖与entry或者application模块来运行。
//特点：多个模块引入shared模块内容。最终的时候指挥生成一个hsp模块，进行代码共享。（鼠标移到整个项目文件夹右键
//  选择新建》选择模块》选择Shared Library》名字可以取为commen 因为多放公共的组件 ，工具包  其他的Ability模块引入使用）
//查看common模块的类型在common/module.json5配置文件中，每个模块都可以引入这个common模块中内容。但是最后打包的时候只会产生一份hsp代码减少代码体积。以后修改了公共的代码，其他页面都将直接修改。

//HAR模块
//har和hsp都是属于无法独立运行，但是可以将模块放在主模块中使用。har模块一旦被主模块或者features模块使用，打包的时候独立一份代码放在对应模块中多个模块使用，打包会打包多份文件。
//适合用于存放项目中指定某些业务。从主模块中独立出来。 比如电商项目中：你可以将支付模块，购物车模块，商品列表都是独立为har，在页面中引入使用static Library模块
//步骤1 ：在项目目录下面创建一个文件夹features 步骤2：选中features右键创建一个module  static Library  步骤3：导出和引入和hsp是一样的

//三层目录架构 common 公共特性目录  features 功能模块目录  product 产品层目录 以后所有hap默认但在product中，hsp模块放在common，用于存放公共工具和代码 har模块放在features可以将
//项目拆分为无数个模块，独立管理

//三, 一多开发介绍
// 一多开发：主要包含两个层面
//一次开发，多个设备终端适配运行。不同设备屏幕你们能看到不同布局方案。
//一次开发，根据不同终端设备打包为不同的hap。在每一种终端设备中就能下载对应的安装包。
//一多开发需要用到的技术： 1.媒体查询技术：根据不同的屏幕尺寸用户自己来决定如何布局。2.栅格系统：栅格系统相当于封装好的组件，可以实现页面布局，根据屏幕大小来决定元素排列规则。（底层也是媒体查询）


// import {EmptyView} from 'common'
// import {MainPage} from 'homelibrary'
import { router } from '@kit.ArkUI'
import { BreakPointSystem } from 'common'
@Entry
@Component
struct Index {
  @State countdown:number = 3
  private timer:number = 0
  private breakPointSystem = new BreakPointSystem()
  @StorageProp('currentBreakpoint') currentBreakpoint:string = 'sm'
  @State factor:number = 1 //适配因子

  aboutToAppear(): void {
    this.breakPointSystem.register()
    //套一个setTimeout后面执行，让currentBreakpoint初始化完成
    //根据宽度来修改对应的适配因子
    setTimeout(()=>{
      console.log('this.currentBreakpoint',this.currentBreakpoint)
      switch (this.currentBreakpoint) {
        case 'sm':
          this.factor = 1
          break;
        case 'md':
          this.factor = 1.2
          break;
        case 'lg':
          this.factor = 1.6
          break;
        default:
          break;
      }
    },0)
    this.timer = setInterval(()=>{
     if(this.countdown>0){
       this.countdown -= 1
     }else{
       clearInterval(this.timer)
       router.pushUrl({
         url: 'pages/Page02_commonMedia'
       })
     }
   },1000)
  }

  aboutToDisappear(): void {
    this.breakPointSystem.unregister()
    if(this.timer){
      clearInterval(this.timer)
    }
  }
  build() {
    Column() {
      Flex({ direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
        Column(){
          Image($r('app.media.woniuicon')).width(100 * this.factor).height(100* this.factor).objectFit(ImageFit.Fill).borderRadius(10* this.factor)
          Text(`倒计时：${this.countdown}`).fontSize(16* this.factor).margin({top: 20* this.factor})
        }.justifyContent(FlexAlign.Center).flexGrow(1)
        Column(){
          Image($r('app.media.woniuShop')).width(100* this.factor)
          Text('WoniuMa|超市').margin({top: 20}).fontColor('#acacab').fontSize(20* this.factor).letterSpacing(16* this.factor)
        }.padding({bottom: 100})
      }
    }
    .height('100%')
    .width('100%')
  }
}