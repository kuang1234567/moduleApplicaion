//通过泛型来传递不同类型的类型限制
export class paramsType<T> {
  value: T

  constructor(value: T) {
    this.value = value
  }
}