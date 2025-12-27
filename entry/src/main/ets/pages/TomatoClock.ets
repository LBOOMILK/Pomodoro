// pages/TomatoClock.ets
@Component
export struct TomatoClock {
  @State timeRemaining: number = 3 ; // 25分钟，单位秒//25 * 60//测试时先用3s
  @State isRunning: boolean = false;
  @State timer: number = 0;

  build() {
    Column() {
      //=================== 页面标题 ===================
      Text('番茄时钟')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 30, bottom: 50 })

      //=================== 时钟显示区域 ===================
      Row() {
        Text(Math.floor(this.timeRemaining / 60).toString().padStart(2, '0'))
          .fontSize(48)
          .fontColor($r('app.color.text_primary'))
        Text(':')
          .fontSize(48)
          .fontColor($r('app.color.text_primary'))
          .margin({ left: 5, right: 5 })
        Text((this.timeRemaining % 60).toString().padStart(2, '0'))
          .fontSize(48)
          .fontColor($r('app.color.text_primary'))
      }
      .margin({ bottom: 40 })

      //=================== 控制按钮区域 ===================
      Row() {
        Button(this.isRunning ? '暂停' : '开始')
          .backgroundColor($r('app.color.primary_blue'))
          .fontColor($r('app.color.text_primary'))
          .width(120)
          .height(45)
          .borderRadius(20)
          .onClick(() => {
            this.toggleTimer();
          })
          .margin({ right: 20 })

        Button('重置')
          .backgroundColor($r('app.color.button_disabled'))
          .fontColor($r('app.color.text_secondary'))
          .width(120)
          .height(45)
          .borderRadius(20)
          .onClick(() => {
            this.resetTimer();
          })
      }
    }
    //=================== 页面整体样式 ===================
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.background_secondary'))
  }

  //=================== 计时器控制方法 ===================
  // 切换计时器状态
  toggleTimer() {
    if (this.isRunning) {
      this.stopTimer();
    } else {
      this.startTimer();
    }
    this.isRunning = !this.isRunning;
  }

  // 开始计时
  startTimer() {
    this.timer = setInterval(() => {
      if (this.timeRemaining > 0) {
        this.timeRemaining -= 1;
      } else {
        this.stopTimer();
        // 这里可以添加完成提示
        // 完成后可以播放提示音或震动
      }
    }, 1000);
  }

  // 停止计时
  stopTimer() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = 0;
    }
  }

  // 重置计时器
  resetTimer() {
    this.stopTimer();
    this.timeRemaining = 3; // 重置为25分钟//25 * 60//测试3s
    this.isRunning = false;
  }

  //=================== 生命周期方法 ===================
  // 页面离开时清理计时器
  aboutToDisappear() {
    this.stopTimer();
  }
}