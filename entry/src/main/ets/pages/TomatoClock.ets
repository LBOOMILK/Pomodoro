// pages/TomatoClock.ets
@Component
export struct TomatoClock {
  @State timeRemaining: number = 25 * 60; // 25分钟，单位秒
  @State isRunning: boolean = false;
  @State timer: number = 0;

  build() {
    Column() {
      // 标题
      Text('番茄时钟')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 50 })

      // 时钟显示
      Row() {
        Text(Math.floor(this.timeRemaining / 60).toString().padStart(2, '0'))
          .fontSize(48)
          .fontColor('#333333')
        Text(':')
          .fontSize(48)
          .fontColor('#333333')
          .margin({ left: 5, right: 5 })
        Text((this.timeRemaining % 60).toString().padStart(2, '0'))
          .fontSize(48)
          .fontColor('#333333')
      }
      .margin({ bottom: 40 })

      // 控制按钮
      Row() {
        Button(this.isRunning ? '暂停' : '开始')
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .width(120)
          .height(45)
          .onClick(() => {
            this.toggleTimer();
          })
          .margin({ right: 20 })

        Button('重置')
          .backgroundColor('#E5E5E5')
          .fontColor('#333333')
          .width(120)
          .height(45)
          .onClick(() => {
            this.resetTimer();
          })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

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
    this.timeRemaining = 25 * 60;
    this.isRunning = false;
  }

  // 页面离开时清理计时器
  aboutToDisappear() {
    this.stopTimer();
  }
}