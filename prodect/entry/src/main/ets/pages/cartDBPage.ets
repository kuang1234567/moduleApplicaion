import { CartModel } from 'common/src/main/ets/comonModel/cartModel';
import { relationalStore } from '@kit.ArkData'
import {cartDBUtils,preferencesUtil,kVStore} from "common"
@Entry
@Component
struct MarqueeExample {
  @State myId: number = 0
  @State count: number = 0
  @State carts: CartModel[] = []
  @State username:string = ""

  aboutToAppear(): void {
    preferencesUtil.readData("theme")
  }

  build() {
    Column() {
      Button('设置主题 blue').onClick((event:ClickEvent)=>{
        preferencesUtil.insert('theme','blue')
      })

      Button('获取主题 blue').onClick((event:ClickEvent)=>{
        const result = preferencesUtil.readData('theme')
        console.log(`result:${result}`)
      })



      TextInput({placeholder:"请输入用户名",text:$$this.username})
      Button("存储数据").onClick((event: ClickEvent) => {
        kVStore.insert("username",this.username)
        kVStore.insert("classes",JSON.stringify({id:1,name:"xiaofeifei"}))
      })
      Button("获取数据").onClick((event: ClickEvent) => {
        kVStore.getData("username").then(res=>{
          console.log(`res:${res}`)
        })
        kVStore.getData("classes").then(res=>{
          console.log(`res2:${res}`)
        })
      })
    }
    .backgroundColor("#f1f3f5")
  }
}