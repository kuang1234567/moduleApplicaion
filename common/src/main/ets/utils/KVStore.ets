//键值数据库
//1.概念：首选项更多的系统变量。比如主题，字体，用户个性化配置等等。
//键值数据库：存储数据的能力比首选项更强，存储更大的数据，和更复杂的数据
//关系型数据库：处理负责的业务，比如学生包含老师，老师包含教室，教室包含办公用品。
//键值类型的数据库，一般字符串或者json格式来作为我们存储对象。需要用那一部分内容，读取内存加载。

import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

export class KVStore {
  //kvManager代表数据库管理对象
  private kvManager: distributedKVStore.KVManager | undefined = undefined;
  //管理数据库里面数据列表
  private kvStore: distributedKVStore.SingleKVStore | undefined = undefined;

  init(context: Context) {
    //定义数据库初始化需要的字段
    const kvManagerConfig: distributedKVStore.KVManagerConfig = {
      context: context,
      bundleName: 'com.jnks.moduleApplication' //跨端流转时用到
    };
    try {
      // 创建KVManager实例 function(value1,value2){value1/value2}
      this.kvManager = distributedKVStore.createKVManager(kvManagerConfig);
      console.info('Succeeded in creating KVManager.');
      // 继续创建获取数据库
    } catch (e) {
      let error = e as BusinessError;
      console.error(`Failed to create KVManager. Code:${error.code},message:${error.message}`);
    }
  }
  //创建并获取键值数据库
  createStore(storeId: string) {
    try {
      //定义store基本参数
      const options: distributedKVStore.Options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: false,
        // kvStoreType不填时，默认创建多设备协同数据库
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
        securityLevel: distributedKVStore.SecurityLevel.S1
      };

      this.kvManager = this.kvManager as distributedKVStore.KVManager
      this.kvManager.getKVStore<distributedKVStore.SingleKVStore>(storeId, options,
        (err, store: distributedKVStore.SingleKVStore) => {
          if (err) {
            console.error(`Failed to get KVStore: Code:${err.code},message:${err.message}`);
            return;
          }
          console.info('Succeeded in getting KVStore.');
          this.kvStore = store;
        });
    } catch (e) {
      let error = e as BusinessError;
      console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  }
  //添加键值数据
  insert(key: string, value: string) {
    try {
      this.kvStore = this.kvStore as distributedKVStore.SingleKVStore
      this.kvStore.put(key, value, (err) => {
        if (err !== undefined) {
          console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
          return;
        }
        console.info('Succeeded in putting data.');
      });
    } catch (e) {
      let error = e as BusinessError;
      console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  }
  //获取数据
  getData(key:string) {
    return new Promise((resolve: (value: string | number | boolean | Uint8Array) => void,
      reject: (value?: string) => void) => {
      this.kvStore = this.kvStore as distributedKVStore.SingleKVStore
      this.kvStore.get(key, (err, data) => {
        if (err != undefined) {
          console.error(`Failed to get data. Code:${err.code},message:${err.message}`);
          reject("查询失败")
          return;
        }
        console.info(`Succeeded in getting data. Data:${data}`);
        resolve(data)
      });
    })
  }
}

const kVStore = new KVStore()
export {kVStore}