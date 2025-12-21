// pages/Placeholder.ets
@Component
export struct Placeholder {
  build() {
    Column() {
      Text('待定页面')
        .fontSize(24)
        .fontColor('#666666')
        .margin({ bottom: 20 })

      Text('这里可以添加其他功能')
        .fontSize(16)
        .fontColor('#999999')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}