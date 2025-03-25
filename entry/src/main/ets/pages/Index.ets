import {EmptyView} from 'common'
@Entry
@Component
struct Index {
  build() {
    Column(){
      Text('hh')
      EmptyView()
    }.width('100%').height('100%')
  }
}