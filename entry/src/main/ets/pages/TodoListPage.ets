// TodoPage.ets - 圆角方框版本
// 常量定义
interface ConstantsType {
  FULL_LENGTH: string;
  TITLE_WIDTH: string;
  COLUMN_SPACE: number;
  PAGE_BACKGROUND: string;
  LIST_ITEM_HEIGHT: number;
  LIST_BORDER_RADIUS: number;
}

const Constants: ConstantsType = {
  FULL_LENGTH: '100%',
  TITLE_WIDTH: '100%',
  COLUMN_SPACE: 16,  // 减小间距
  PAGE_BACKGROUND: '#F5F5F5',
  LIST_ITEM_HEIGHT: 64,  // 添加项目高度
  LIST_BORDER_RADIUS: 24  // 添加圆角半径
};

// 数据
class TodoData {
  static getData(): string[] {
    return [
      '学习ArkTS基础',
      '复现Todo页面',
      '掌握组件开发',
      '准备番茄钟项目'
    ];
  }
}

// 待办项组件 - 修改圆角和样式
@Component
export struct TodoItem {
  @Prop content: string = '';
  @State isCompleted: boolean = false;

  build() {
    Row({ space: 12 }) {  // 增加间距
      // 复选框区域
      Column() {
        Stack() {
          Circle()
            .width(20)
            .height(20)
            .fill(this.isCompleted ? $r('app.color.SkyBlue') : $r('app.color.White'))
            .stroke(this.isCompleted ? $r('app.color.SkyBlue') : $r('app.color.Gray'))
            .strokeWidth(1.5)

          if (this.isCompleted) {
            Text('✓')
              .fontSize(12)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
          }
        }
        .width(24)
        .height(24)
      }
      .onClick(() => {
        this.isCompleted = !this.isCompleted;
      })

      // 文本区域
      Text(this.content)
        .fontSize(16)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)  // 添加字体粗细
        .opacity(this.isCompleted ? 0.4 : 1)  // 完成时透明度变化
        .decoration({ type: this.isCompleted ? TextDecorationType.LineThrough : TextDecorationType.None })
        .flexGrow(1)  // 让文本占满剩余空间
    }
    .width('93%')  // 改为93%，留出灰色背景空间
    .height(Constants.LIST_ITEM_HEIGHT)
    .padding({ left: 20, right: 20 })  // 左右内边距
    .backgroundColor(Color.White)
    .borderRadius(Constants.LIST_BORDER_RADIUS)  // 使用圆角常量
    .margin({
      left: '3.5%',  // 自动计算左右边距
      right: '3.5%',
      bottom: 12
    })
  }
}

@Component
struct TodoListPage {
  @State totalTasks: string[] = [];

  aboutToAppear() {
    this.totalTasks = TodoData.getData();
  }

  build() {
    Column({ space: Constants.COLUMN_SPACE }) {
      Text('   我的待办清单')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .lineHeight(36)
        .width(Constants.TITLE_WIDTH)
        .margin({ top: 40, bottom: 20 })
        .textAlign(TextAlign.Start)

      // 使用Scroll和Column包装列表
      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.totalTasks, (item: string) => {
            TodoItem({ content: item })
          }, (item: string) => item)
        }
        .width('100%')
        .padding({ bottom: 20 })  // 只保留底部padding  // 上下内边距
      }
      .width('100%')
      .margin({ top: -10 })  // 负边距抵消多余空间
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.PAGE_BACKGROUND)
  }
}

export { TodoListPage };
