@Component
export struct MainPage {
  @State message: string = 'homeLibrary';

  build() {
    Column(){
      Text(this.message)
    }
  }
}
