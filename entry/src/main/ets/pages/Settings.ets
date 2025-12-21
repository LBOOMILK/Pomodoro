// pages/Settings.ets
@Component
export struct Settings {
  @StorageLink('themeColor') themeColor: string = '#007DFF';
  @StorageLink('fontSize') fontSize: number = 16;

  build() {
    Column() {
      // 标题
      Text('设置')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 30 })

      // 主题颜色设置
      List() {
        ListItem() {
          Row() {
            Text('主题颜色')
              .fontSize(this.fontSize)
            Blank()
            Text(this.themeColor)
              .fontSize(this.fontSize)
              .fontColor('#999999')
          }
          .padding(15)
        }
        .onClick(() => {
          // 这里可以弹出颜色选择器
        })

        // 字体大小设置
        ListItem() {
          Row() {
            Text('字体大小')
              .fontSize(this.fontSize)
            Blank()
            Text(`标准 (${this.fontSize}px)`)
              .fontSize(this.fontSize)
              .fontColor('#999999')
          }
          .padding(15)
        }
        .onClick(() => {
          // 这里可以弹出字体大小选择
        })

        // 应用信息
        ListItem() {
          Row() {
            Text('应用信息')
              .fontSize(this.fontSize)
            Blank()
            Image($r('app.media.ic_right'))
              .width(16)
              .height(16)
          }
          .padding(15)
        }
        .onClick(() => {
          // 这里可以跳转到应用信息页面s
        })

        // 登录/退出
        ListItem() {
          Row() {
            Text('登录账户')
              .fontSize(this.fontSize)
            Blank()
            Image($r('app.media.ic_right'))
              .width(16)
              .height(16)
          }
          .padding(15)
        }
        .onClick(() => {
          // 这里可以处理登录逻辑
        })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 20, right: 20 })
  }
}