//创建关系型数库存储

import { relationalStore } from '@kit.ArkData'; // 导入模块
import { BusinessError } from '@kit.BasicServicesKit';
import { CartModel } from 'common/src/main/ets/comonModel/cartModel';

class CartDBUtils {
  private  rdbStore:relationalStore.RdbStore | null = null
  /**
   *初始化数据
   * @param context 全局上下文对象
   * @param tableName 表名
   * */
  initCartDB(context:Context,tableName:string){
    //(1)初始化数据库配置
    const STORE_CONFIG: relationalStore.StoreConfig= {
      name: 'woNiuMall.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
      encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
      // customDir: 'customDir/subCustomDir', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
      isReadOnly: false // 可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
    };
    //(2)定义spl语句
    const SQL_CREATE_TABLE =
      `CREATE TABLE IF NOT EXISTS ${tableName} (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      GOODS_NAME TEXT NOT NULL,
      GOODS_BIG_LOGO TEXT,
      GOODS_CODE TEXT,
      GOODS_PRICE REAL,
      GOODS_COUNT INTEGER,
      GOODS_CHECKED INTEGER)`;
    ; // 建表Sql语句, IDENTITY为bigint类型，sql中指定类型为UNLIMITED INT AGE INTEGER, SALARY REAL,CODES BLOB,IDENTITY UNLIMITED INT
    //(3)初始化数据库(getRdbStore异步)
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`获取RdbStore失败. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('获取RdbStore成功')
      this.rdbStore = store

      //有了数据库，就可以创建表格
      store.executeSql(SQL_CREATE_TABLE, (error) => {
        if (!error) {
          console.log(`${tableName}创建成功`)
        } else {
          console.log(`${tableName}创建失败`)
        }
      });
    })
  }

  /**
   * 添加数据到数据库   获取到RdbStore，完成数据表创建后，调用insert()接口插入数据
   * @param tableName 表名
   * */
  insertDataDB(tableName:string,value:relationalStore.ValuesBucket){
    if(this.rdbStore !== null){
      this.rdbStore.insert(tableName,value,(err:BusinessError,rowId:number)=>{
        if(err){
          console.log(`往${tableName}中添加数据失败}`)
          return;
        }
        console.log(`往${tableName}中添加数据成功，rowId：${rowId}`)
      })
    }

  }

  /**
   * 提取数据库中的数据
   * @param column 投影列 ["ID","NAME"]
   * @param tableName
   */
  async queryDataDB(column: Array<string>, tableName: string, id?: number) {
    //获取要操作对象
    let predicates1 = new relationalStore.RdbPredicates(tableName);
    if(id){
      //筛选条件.选中指定数据
      predicates1.equalTo('ID', id);
    }
    //查询到的所有对象
    let carts:CartModel[] = [];
    //查询数据得到一个结果集，resultSet = [数据库内容]
    //想办法将结果集转化为CartModel
    const resultSet = await (this.rdbStore as relationalStore.RdbStore).query(predicates1,column)
    //goToNextRow判断结果集是否往下指向下一个数据
    //ORM: 对象和数据库 进行数据转换。
    while(resultSet.goToNextRow()){
      //getColumnIndex找到数据库中指定某一行的列名
      //getString指定列的值获取到
      let id = resultSet.getString(resultSet.getColumnIndex("ID"))
      let goods_name = resultSet.getString(resultSet.getColumnIndex("GOODS_NAME"))
      let goods_big_logo = resultSet.getString(resultSet.getColumnIndex("GOODS_BIG_LOGO"))
      let goods_code = resultSet.getString(resultSet.getColumnIndex("GOODS_CODE"))
      let goods_price = resultSet.getDouble(resultSet.getColumnIndex("GOODS_PRICE"))
      let goods_count = resultSet.getLong(resultSet.getColumnIndex("GOODS_COUNT"))
      let goods_checked = resultSet.getLong(resultSet.getColumnIndex("GOODS_CHECKED"))

      const temp:CartModel = new CartModel()
      temp.id = id
      temp.goods_name = goods_name
      temp.goods_big_logo = goods_big_logo
      temp.goods_code = goods_code
      temp.goods_price = goods_price
      temp.goods_count = goods_count
      temp.goods_checked = goods_checked

      carts.push(temp)
    }
    //释放内存的结果集
    resultSet.close()
    return carts
  }
  /**
   * 删除数据
   * @param tableName
   * @param id
   * */
  deleteById(tableName:string,id:string){
    //获取要操作对象
    //获取要操作对象
    let predicates1 = new relationalStore.RdbPredicates(tableName);
    //筛选条件.选中指定数据
    predicates1.equalTo('ID', id);
    if (this.rdbStore !== null) {
      this.rdbStore.delete(predicates1, (err: BusinessError, rows: number) => {
        if (err) {
          console.error(`Failed to delete data. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`Delete rows: ${rows}`);
      })
    }
  }
  /**
   * 修改数据
   * @param tableName 表名
   * @param id 修改的商品编号
   * @param value 修改的字段
   * */
  updateById(tableName:string,id:number,value:relationalStore.ValuesBucket){
    //获取要操作对象
    let predicates1 = new relationalStore.RdbPredicates(tableName);
    //筛选条件.选中指定数据
    predicates1.equalTo('ID', id);
    if(this.rdbStore != null){
      this.rdbStore.update(value,predicates1,(err: BusinessError, rows: number)=>{
        if (err) {
          console.error(`修改失败 Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`修改成功 rows: ${rows}`);
      })
    }
  }
}

const cartDBUtils = new CartDBUtils()
export {cartDBUtils}

//sql
//关系数据库采用了spl语句来进行数据的增删改查
//鸿蒙底层关系型数据库默认用sqlite，开源的数据库
//INTEGER：整数  REAL：浮点型  TEXT：文本字符串   BOOLEAN: 布尔型  BLOB：可以存放大文件，或者二进制类型
//字段名字  字段数据类型  字段约束
//ID INTEGER (PRIMARY KEY AUTOINCREMENT)
//create table cart (
// ID INTEGER PRIMARY KEY AUTOINCREMENT,
// GOODS_NAME TEXT NOT NULL,
// GOODS_PRICE REAL,
// )

//执行增删改查都会对应sql语句
//query()   会去执行 select ID，GOODS_NAME from cart where ID = 1 查询语句
//insert()  会去执行 insert into cart (GOODS_NAME) value ('华为')

