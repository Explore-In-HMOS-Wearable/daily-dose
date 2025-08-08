@Component
export struct MedicineInput {
  @Link reminderAnyText: string
  @Prop inputName: string | Resource
  @Prop isTime: boolean
  controller?: TextInputController

  build() {
    Column() {
      Text(this.inputName)
        .fontSize(13)
        .fontColor(Color.Gray)

      TextInput({ controller: this.controller, text: this.reminderAnyText })
        .fontColor(Color.White)
        .onChange(val => this.reminderAnyText = val)
        .width('85%')
        .height(28)
        .backgroundColor(Color.Gray)
        .borderRadius(6)
        .fontSize(13)
        .padding(5)
        .fontColor(this.reminderAnyText ? Color.Black : Color.Gray)
        .type(this.isTime ? InputType.Number : InputType.Normal)
    }
  }
}

