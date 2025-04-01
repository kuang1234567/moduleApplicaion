import {BreakPointSystem} from 'common'
@Entry
@Component
struct Page02_commonMedia {
  //放到index页面注册
  private breakPointSystem = new BreakPointSystem()
  @StorageProp('currentBreakpoint') currentBreakpoint:string = 'sm'

  //注册媒体查询监听屏幕宽度事件
  aboutToAppear(): void {
    this.breakPointSystem.register()
  }
  //注销媒体查询监听屏幕宽度事件
  aboutToDisappear(): void {
    this.breakPointSystem.unregister()
  }
  build() {
      Column(){
          Text(this.currentBreakpoint).fontSize(30).fontColor(Color.Red)
      }
  }
}