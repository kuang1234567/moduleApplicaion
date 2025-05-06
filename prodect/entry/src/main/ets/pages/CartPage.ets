import { ShopCarPage } from './shopCarPage'

@Entry
@Component
struct CartPage {
  build() {
    Column(){
      ShopCarPage()
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#f1f3f5")
  }
}