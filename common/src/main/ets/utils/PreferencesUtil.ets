//用户首选项
//用户首选项提供一个全局存储能力，这个数据存储在内存种的时候，可以选择持久化数据到硬盘。
//如果从磁盘里面读取出来。一次性加载数据到内存。
//适合存储一些项目中全局的变量。比如全局主题颜色，全局字体大小等等
//不适合存储大量产品，订单，日志等等

import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

export class PreferencesUtil {
  private dataPreferences: preferences.Preferences | null = null;

  /**
   * 初始化preferences对象
   * @param context 上下文对象
   */
  init(context: Context, storeName: string) {
    let options: preferences.Options = { name: storeName };
    this.dataPreferences = preferences.getPreferencesSync(context, options);

    //on就是会数据设置监听效果
    let observer = (key: string) => {
      //持久化硬盘 调用.flush()将数据存储到硬盘
      (this.dataPreferences as preferences.Preferences).flush((err: BusinessError) => {
        if (err) {
          console.error(`Failed to flush. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info('Succeeded in flushing.');
      })
    }
    this.dataPreferences.on('change', observer);
  }

  insert(key: string, value: string) {
    //判断this.dataPreferences 不等于null
    if (this.dataPreferences) {
      if (this.dataPreferences.hasSync(key)) {
        console.info(`已经存在key：${key}`);
      } else {
        // 此处以此键值对不存在时写入数据为例
        this.dataPreferences.putSync(key, value);
        console.log("添加成功")
      }
    }
  }

  readData(key: string, value?: string) {
    if (this.dataPreferences) {
      let val = this.dataPreferences.getSync(key, value ? value : "default");
      console.info(`The '${key}' value is " + ${val}`);
      return val
    }else{
      return "查询错误"
    }

  }

  update(){

  }
}

const preferencesUtil = new PreferencesUtil()

export { preferencesUtil }