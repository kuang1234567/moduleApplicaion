@Component
export  struct EmptyView {
  @State message: string = 'common'

  build() {
    Column(){
      Text(this.message)
    }
  }
}