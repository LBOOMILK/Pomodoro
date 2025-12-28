// pages/Settings.ets
@Component
export struct Settings {
  @StorageLink('globalFontSize') fontSize: number = 16;

  // 字体大小选项
  private fontSizes: number[] = [12, 14, 16, 18, 20, 24];
  private fontSizeNames: string[] = ['较小', '小', '标准', '大', '较大', '特大'];

  build() {
    Scroll() {
      Column() {
        //=================== 用户信息区域 ===================
        Column() {
          Circle()
            .width(80)
            .height(80)
            .fill($r('app.color.primary_blue'))
            .margin({ bottom: 12 })

          Text('未登录用户')
            .fontSize(this.fontSize + 4)  // 使用动态字体大小，+4表示比正文大
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 4 })

          Text('点击登录以同步数据')
            .fontSize(this.fontSize - 2)  // 使用动态字体大小，-2表示比正文小
            .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
        .padding({ top: 40, bottom: 30 })
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(16)
        .alignItems(HorizontalAlign.Center)
        .margin({ bottom: 20 })

        //=================== 设置项区域 ===================
        // 主题设置卡片
        Column() {
          Row() {
            Text('主题设置')
              .fontSize(this.fontSize + 2)  // 标题比正文字体大2
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .flexGrow(1)
          }
          .padding({ top: 16, left: 16, right: 16, bottom: 12 })

          // 主题说明
          Text('跟随系统主题自动切换')
            .fontSize(this.fontSize)  // 使用当前字体大小
            .fontColor($r('app.color.text_tertiary'))
            .padding({ left: 16, right: 16, bottom: 16 })
        }
        .width('100%')
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(16)
        .margin({ bottom: 12 })

        // 字体大小设置卡片
        Column() {
          Row() {
            Text('字体大小')
              .fontSize(this.fontSize + 2)  // 标题比正文字体大2
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .flexGrow(1)
          }
          .padding({ top: 16, left: 16, right: 16, bottom: 12 })

          // 当前字体大小显示 - 使用当前字体大小显示自身
          Row() {
            Text('当前：')
              .fontSize(this.fontSize)  // 使用当前字体大小
              .fontColor($r('app.color.text_secondary'))
            Text(`${this.fontSize}px (${this.getFontSizeName(this.fontSize)})`)
              .fontSize(this.fontSize)  // 使用当前字体大小
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Medium)
          }
          .padding({ left: 16, right: 16, bottom: 12 })

          // 字体大小按钮组
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            ForEach(this.fontSizes, (size: number, index: number) => {
              Column() {
                // 按钮上的字体大小数字 - 动态调整
                Text(`${size}px`)
                  .fontSize(size === 12 ? 10 : Math.max(10, size - 4))
                  .fontColor(size === this.fontSize ?
                    $r('app.color.White') :
                    $r('app.color.text_primary'))
                // 按钮上的描述文字
                Text(this.fontSizeNames[index])
                  .fontSize(12)  // 描述文字保持固定大小
                  .fontColor(size === this.fontSize ?
                    $r('app.color.White') :
                    $r('app.color.text_tertiary'))
                  .margin({ top: 2 })
              }
              .width('30%')
              .height(60)
              .backgroundColor(size === this.fontSize ?
                $r('app.color.primary_blue') :
                $r('app.color.background_tertiary'))
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .margin({ bottom: 8 })
              .onClick(() => {
                // 直接赋值，StorageLink会自动同步
                this.fontSize = size;
              })
            }, (size: number) => size.toString())
          }
          .padding({ left: 16, right: 16, bottom: 16 })
        }
        .width('100%')
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(16)
        .margin({ bottom: 12 })

        // 应用信息卡片
        Column() {
          Row() {
            Text('应用信息')
              .fontSize(this.fontSize + 2)  // 标题比正文字体大2
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .flexGrow(1)

            Image($r('app.media.ic_right'))
              .width(16)
              .height(16)
          }
          .padding(16)
        }
        .width('100%')
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(16)
        .margin({ bottom: 12 })

        // 关于我们卡片
        Column() {
          Row() {
            Text('关于我们')
              .fontSize(this.fontSize + 2)  // 标题比正文字体大2
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .flexGrow(1)

            Image($r('app.media.ic_right'))
              .width(16)
              .height(16)
          }
          .padding(16)
        }
        .width('100%')
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(16)

        // 版本信息 - 使用比正文字体小2
        Text('番茄钟 v1.0.0')
          .fontSize(this.fontSize - 2)
          .fontColor($r('app.color.text_tertiary'))
          .margin({ top: 24, bottom: 40 })
          .width('100%')
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_secondary'))
  }

  // 获取字体大小对应的名称
  private getFontSizeName(size: number): string {
    const index = this.fontSizes.indexOf(size);
    return index >= 0 ? this.fontSizeNames[index] : '自定义';
  }
}