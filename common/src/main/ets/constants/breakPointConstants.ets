//媒体查询工具他属于公共开发工具，以后任何hap模块，获取其他模块都可以使用这个工具。
// 代码就放在common的hsp模块中进行封装哪个模块要用，直接引入共享。
//媒体查询封装工具
//1.封装常量
//开发媒体查询有很多常量使用，这些常量都封装为一个媒体查询的常量文件。 考虑到媒体查询工具是公共的工具，我们可以将这个工具放在common模块的utils中


//媒体查询断点常量
export class BreakPointConstants {
  //这个单位一般代表手机 xs就没有加入
  static readonly BREAKPOINT_SM: string = 'sm'
  //这个单位一般代表折叠屏
  static readonly BREAKPOINT_MD: string = 'md'
  //这个单位一般代表pad
  static readonly BREAKPOINT_LG: string = 'lg'

  //断点数组
  static readonly BREAKPOINT_VALUE: Array<string> = ['320vp','600vp','840vp']

  //Columns 在水平方向占多少列
  static readonly COLUMN_SM:number = 4
  static readonly COLUMN_MD:number = 8
  static readonly COLUMN_LG:number = 12

  //字符串常量 用于应用存储的字符
  static readonly  CURRENT_BREAKPOINT:string = 'currentBreakpoint'

  //字体大小
  static readonly FONT_SIZE_SM:number = 14
  static readonly FONT_SIZE_MD:number = 16
  static readonly FONT_SIZE_LG:number = 18

  //屏幕宽度范围 用于判断是那种设备
  static readonly RANGE_SM:string = '(320vp<=width<600vp)'
  static readonly RANGE_MD:string = '(600vp<=width<840vp)'
  static readonly RANGE_LG:string = '(840vp<=width)'
}