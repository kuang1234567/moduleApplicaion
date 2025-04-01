import {BreakPointConstants} from  '../constants/breakPointConstants'
import { mediaquery } from '@kit.ArkUI';

export class BreakPointSystem {
  //媒体查询，得到单位要将这个sm md lg
  private currentBreakpoint:string =BreakPointConstants.BREAKPOINT_SM
  //屏幕大小条件查询
  private smListener:mediaquery.MediaQueryListener = mediaquery.matchMediaSync(BreakPointConstants.RANGE_SM)
  private mdListener:mediaquery.MediaQueryListener = mediaquery.matchMediaSync(BreakPointConstants.RANGE_MD)
  private lgListener:mediaquery.MediaQueryListener = mediaquery.matchMediaSync(BreakPointConstants.RANGE_LG)

  //定义公共函数，目的保存当前屏幕的监测结果
  private updateCurrentBreakpoint(breakpoint:string){
    if(this.currentBreakpoint !== breakpoint){
      this.currentBreakpoint = breakpoint
      //应用存储
      AppStorage.setOrCreate<string>(BreakPointConstants.CURRENT_BREAKPOINT,this.currentBreakpoint)
    }
  }

  //给监听器绑定change事件
  private isBreakpointSM = (mediaQueryResult:mediaquery.MediaQueryResult)=>{
      if(mediaQueryResult.matches){
        //将sm单位保存起来
        console.log('sm')
        this.updateCurrentBreakpoint(BreakPointConstants.BREAKPOINT_SM)
      }
  }
  private isBreakpointMd = (mediaQueryResult:mediaquery.MediaQueryResult)=>{
    if(mediaQueryResult.matches){
      //将md单位保存起来
      console.log('md')
      this.updateCurrentBreakpoint(BreakPointConstants.BREAKPOINT_MD)
    }
  }
  private isBreakpointLG = (mediaQueryResult:mediaquery.MediaQueryResult)=>{
    if(mediaQueryResult.matches){
      //将lg单位保存起来
      console.log('lg')
      this.updateCurrentBreakpoint(BreakPointConstants.BREAKPOINT_LG)
    }
  }

  //在引用的地方调用给监听器绑定事件
  public register() {
    this.smListener.on('change',this.isBreakpointSM)
    this.mdListener.on('change',this.isBreakpointMd)
    this.lgListener.on('change',this.isBreakpointLG)
  }

  //解除事件绑定，避免造成内存泄露
  public unregister(){
    this.smListener.off('change',this.isBreakpointSM)
    this.mdListener.off('change',this.isBreakpointMd)
    this.lgListener.off('change',this.isBreakpointLG)
  }



}