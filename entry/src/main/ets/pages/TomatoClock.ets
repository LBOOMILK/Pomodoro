// TomatoClock.ets
import { FontUtils } from '../utils/FontUtils';
import prompt from '@ohos.prompt';

@Component
export struct TomatoClock {
  @StorageLink('globalFontSize') fontSize: number = 16;

  // 状态变量
  @State timeRemaining: number = 25 * 60;  // 默认25分钟
  @State isRunning: boolean = false;
  @State isWorkMode: boolean = true;      // true=工作时间, false=休息时间
  @StorageLink('completedPomodoros') completedPomodoros: number = 0;  // 完成的番茄数，持久化保存
  @State timerId: number = 0;
  @State speedMultiplier: number = 1;     // 时间流速倍数，1=正常，2=2倍速，5=5倍速

  // 配置
  @StorageLink('workDuration') workDuration: number = 25 * 60;  // 25分钟，持久化保存
  @StorageLink('breakDuration') breakDuration: number = 5 * 60;  // 5分钟，持久化保存
  private readonly longBreakDuration: number = 15 * 60; // 15分钟
  private readonly pomodorosBeforeLongBreak: number = 4;

  // 计算进度百分比（随着时间增加而增加，表示已完成的时间比例）
  get progressPercentage(): number {
    const totalTime = this.isWorkMode ? this.workDuration : this.breakDuration;
    return ((totalTime - this.timeRemaining) / totalTime) * 100;
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        //=================== 页面标题 ===================
        Text(this.isWorkMode ? '🍅 工作时间' : '☕ 休息时间')
          .fontSize(FontUtils.getTitleSize(this.fontSize))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ top: 30 })

        //=================== 完成番茄数统计 ===================
        Row() {
          Text('已完成：')
            .fontSize(FontUtils.getBodySize(this.fontSize))
            .fontColor($r('app.color.text_secondary'))
          Text(`${this.completedPomodoros} 个番茄`)
            .fontSize(FontUtils.getBodySize(this.fontSize))
            .fontColor($r('app.color.primary_blue'))
            .fontWeight(FontWeight.Medium)
        }
        .margin({ bottom: 10 })

        //=================== 时钟显示区域 ===================
        Column() {
          // 进度环
          Stack() {
            // 背景环
            Circle()
              .width(250)
              .height(250)
              .fill('transparent')
              .stroke($r('app.color.background_tertiary'))
              .strokeWidth(15)

            // 进度环
            Circle()
              .width(250)
              .height(250)
              .fill('transparent')
              .stroke(this.isWorkMode ? $r('app.color.primary_red') : $r('app.color.primary_green'))
              .strokeWidth(15)
              .strokeDashArray([this.progressPercentage * 6.28, 6.28]) // 2πr ≈ 6.28

            // 时间显示
            Row() {
              Text(Math.floor(this.timeRemaining / 60).toString().padStart(2, '0'))
                .fontSize(60)
                .fontColor($r('app.color.text_primary'))
                .fontWeight(FontWeight.Bold)
              Text(':')
                .fontSize(60)
                .fontColor($r('app.color.text_primary'))
                .fontWeight(FontWeight.Bold)
                .margin({ left: 5, right: 5 })
              Text((this.timeRemaining % 60).toString().padStart(2, '0'))
                .fontSize(60)
                .fontColor($r('app.color.text_primary'))
                .fontWeight(FontWeight.Bold)
            }
          }

          // 模式说明
          Text(this.isWorkMode ? '专注工作，避免分心' : '放松休息，准备下一轮')
            .fontSize(FontUtils.getSmallSize(this.fontSize))
            .fontColor($r('app.color.text_tertiary'))
            .margin({ top: 20 })
        }
        .margin({ bottom: 30 })

        //=================== 控制按钮区域 ===================
        Column({ space: 15 }) {
          // 开始/暂停按钮
          Button(this.isRunning ? '⏸️ 暂停' : '▶️ 开始')
            .width(200)
            .height(50)
            .backgroundColor(this.isRunning ?
              $r('app.color.warning') :
              $r('app.color.primary_green'))
            .fontColor($r('app.color.White'))
            .fontSize(FontUtils.getSmallSize(this.fontSize))
            .borderRadius(25)
            .onClick(() => {
              this.toggleTimer();
            })

          // 重置按钮
          Button('🔄 重置')
            .width(200)
            .height(50)
            .backgroundColor($r('app.color.button_disabled'))
            .fontColor($r('app.color.text_secondary'))
            .fontSize(FontUtils.getSmallSize(this.fontSize))
            .borderRadius(25)
            .onClick(() => {
              this.resetTimer();
            })

          // 切换模式按钮（仅当未运行时显示）
          if (!this.isRunning) {
            Button(this.isWorkMode ? '切换到休息' : '切换到工作')
              .width(200)
              .height(50)
              .backgroundColor($r('app.color.primary_blue'))
              .fontColor($r('app.color.White'))
              .fontSize(FontUtils.getSmallSize(this.fontSize))
              .borderRadius(25)
              .onClick(() => {
                this.switchMode();
              })
              .margin({ top: 10 })
          }

          // 速度控制按钮
          Row({ space: 10 }) {
            Button('正常速度')
              .width(95)
              .height(40)
              .backgroundColor(this.speedMultiplier === 1 ? $r('app.color.primary_green') : $r('app.color.button_disabled'))
              .fontColor(this.speedMultiplier === 1 ? $r('app.color.White') : $r('app.color.text_secondary'))
              .fontSize(FontUtils.getSmallSize(this.fontSize) - 2)
              .borderRadius(20)
              .onClick(() => {
                this.speedMultiplier = 1;
              })

            Button('30倍速')
              .width(95)
              .height(40)
              .backgroundColor(this.speedMultiplier === 30 ? $r('app.color.primary_green') : $r('app.color.button_disabled'))
              .fontColor(this.speedMultiplier === 30 ? $r('app.color.White') : $r('app.color.text_secondary'))
              .fontSize(FontUtils.getSmallSize(this.fontSize) - 2)
              .borderRadius(20)
              .onClick(() => {
                this.speedMultiplier = 30;
              })

            Button('60倍速')
              .width(95)
              .height(40)
              .backgroundColor(this.speedMultiplier === 60 ? $r('app.color.primary_green') : $r('app.color.button_disabled'))
              .fontColor(this.speedMultiplier === 60 ? $r('app.color.White') : $r('app.color.text_secondary'))
              .fontSize(FontUtils.getSmallSize(this.fontSize) - 2)
              .borderRadius(20)
              .onClick(() => {
                this.speedMultiplier = 60;
              })
          }
          .margin({ top: 20 })
        }
        .margin({ bottom: 30 }) // 添加底部边距，确保内容完全可见
      }
      .width('100%')
      .padding(20)
      .backgroundColor($r('app.color.background_secondary'))
    }
    .width('100%')
    .height('100%')
    .edgeEffect(EdgeEffect.Spring)  // 弹性滚动
  }

  //=================== 计时器控制方法 ===================
  // 切换计时器状态
  toggleTimer() {
    if (this.isRunning) {
      this.stopTimer();
    } else {
      this.startTimer();
    }
  }

  // 开始计时
  startTimer() {
    // 彻底清理所有可能存在的计时器
    this.stopTimer();
    
    this.isRunning = true;
    
    // 重新设计计时器逻辑，使用更可靠的实现
    const runTimer = () => {
      if (!this.isRunning) {
        return;
      }
      
      // 根据速度倍数更新时间
      this.timeRemaining = Math.max(0, this.timeRemaining - this.speedMultiplier);
      
      if (this.timeRemaining <= 0) {
        this.handleTimerComplete();
        return;
      }
      
      // 使用setTimeout替代setInterval，避免累积误差和多实例问题
      this.timerId = setTimeout(runTimer, 1000) as number;
    };
    
    // 立即执行一次
    runTimer();
  }

  // 停止计时
  stopTimer() {
    // 清除所有可能存在的计时器
    if (this.timerId) {
      clearTimeout(this.timerId);
      clearTimeout(this.timerId); // 双重保险
    }
    this.timerId = 0;
    this.isRunning = false;
  }

  // 重置计时器
  resetTimer() {
    this.stopTimer();
    this.timeRemaining = this.isWorkMode ? this.workDuration : this.breakDuration;
  }

  // 切换工作/休息模式
  switchMode() {
    this.stopTimer();
    this.isWorkMode = !this.isWorkMode;
    this.timeRemaining = this.isWorkMode ? this.workDuration : this.breakDuration;
  }

  // 处理计时完成
  private handleTimerComplete() {
    this.stopTimer();

    if (this.isWorkMode) {
      // 工作模式完成
      this.completedPomodoros += 1;
      prompt.showToast({
        message: '🎉 恭喜完成一个番茄钟！开始休息吧～',
        duration: 3000
      });

      // 判断是否需要进行长休息
      const breakTime = (this.completedPomodoros % this.pomodorosBeforeLongBreak === 0)
        ? this.longBreakDuration
        : this.breakDuration;

      // 切换到休息模式
      this.isWorkMode = false;
      this.timeRemaining = breakTime;
    } else {
      // 休息模式完成
      prompt.showToast({
        message: '💪 休息结束，开始新的番茄钟吧！',
        duration: 3000
      });

      // 切换回工作模式
      this.isWorkMode = true;
      this.timeRemaining = this.workDuration;
    }
  }

  //=================== 生命周期方法 ===================
  aboutToAppear() {
    // 初始化时间
    this.timeRemaining = this.isWorkMode ? this.workDuration : this.breakDuration;
  }

  aboutToDisappear() {
    this.stopTimer();
  }
}