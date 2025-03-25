@Component
export struct EmptyView {
  build() {
    Column(){
      Text('空空如也')
    }.width('100%').height('100%')
  }
}