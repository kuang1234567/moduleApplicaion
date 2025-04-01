//媒体查询技术
//响应式布局：可以检测当前设备的大小，根据设备大小来决定如何进行元素排列。比如手机端栈100%，在屏幕宽度>500vp的时候，动态控制元素占50%。
//媒体查询技术是实现响应式布局的核心技术。
//断点：用户可以设置屏幕的参考值，以这个值为准让屏幕大小来匹配。匹配完成后就采用某种布局方案。
//320vp-500vp   500vp-720vp
//媒体查询技术：监测屏幕大小。监测设备类型等等。
//栅格系统： 在媒体查询技术上封装好的技术，鸿蒙提供栅格系统
//在页面中用媒体查询和栅格系统配合来实现页面布局

//下面是使用媒体查询来监测屏幕显示方式 这个只是监测了横屏竖屏 真正要实现页面元素的监测，尺寸的监测，可以添加更多的条件

import mediaquery from '@ohos.mediaquery';

@Entry
@Component
struct Page01_media {
  @State message: string = 'Hello World';
  //监测屏幕是否为横屏
  private listener = mediaquery.matchMediaSync('(orientation: landscape)')

  onPortrait = (mediaQueryResult:mediaquery.MediaQueryResult)=>{
    //若设备为横屏状态，matches匹配成功，更改相应的页面布局
    if(mediaQueryResult.matches){
      this.message = '横屏'
    }else {
      this.message = '竖屏'
    }
  }

  aboutToAppear(): void {
    this.listener.on('change',this.onPortrait)
  }
  build() {
    RelativeContainer() {
      Text(this.message).fontSize(30)
    }
    .height('100%')
    .width('100%')
  }
}