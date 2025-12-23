// TodoPage.ets
//=================== 类型定义模块 ===================
//待办事项数据类型定义
interface TodoItemType {
  id: number;
  content: string;
  isCompleted: boolean;
}

// 常量定义类型
interface ConstantsType {
  FULL_LENGTH: string;
  TITLE_WIDTH: string;
  COLUMN_SPACE: number;
  PAGE_BACKGROUND: string;
  LIST_ITEM_HEIGHT: number;
  LIST_BORDER_RADIUS: number;
}

//=================== 常量配置模块 ===================
const Constants: ConstantsType = {
  FULL_LENGTH: '100%',
  TITLE_WIDTH: '100%',
  COLUMN_SPACE: 16,  // 列间距
  PAGE_BACKGROUND: '#F5F5F5',  // 页面背景色
  LIST_ITEM_HEIGHT: 72,  // 列表项高度
  LIST_BORDER_RADIUS: 24  // 列表项圆角半径
};

//=================== 数据管理模块 ===================
class TodoData {
  private static nextId: number = 5;

  // 获取初始数据
  static getData(): TodoItemType[] {
    return [
      { id: 1, content: '学习ArkTS基础', isCompleted: false },
      { id: 2, content: '复现Todo页面', isCompleted: false },
      { id: 3, content: '掌握组件开发', isCompleted: false },
      { id: 4, content: '准备番茄钟项目', isCompleted: false }
    ];
  }

  // 获取下一个任务ID
  static getNextId(): number {
    return TodoData.nextId++;
  }
}

//=================== 待办项组件模块 ===================
@Component
export struct TodoItem {
  @Prop todoItem: TodoItemType;  // 待办事项数据
  //通过属性接收回调函数（替代手动存储的handler）
  onDelete: () => void = () => {};
  onToggle: () => void = () => {};
  onTextChange: (content: string) => void = () => {};
  //=================== 组件构建 ===================
  build() {
    Row({ space: 12 }) {
      //=================== 左侧复选框区域 ===================
      Column() {
        Stack() {
          Circle()
            .width(20)
            .height(20)
            .fill(this.todoItem.isCompleted ? $r('app.color.SkyBlue') : $r('app.color.White'))
            .stroke(this.todoItem.isCompleted ? $r('app.color.SkyBlue') : $r('app.color.Gray'))
            .strokeWidth(1.5)
          // 完成状态显示对勾
          if (this.todoItem.isCompleted) {
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
        this.onToggle?.(); // 直接调用属性传递的回调
      })

      //=================== 中间文本编辑区域 ===================
      TextInput({ text: this.todoItem.content })
        .width('65%')
        .height(32)
        .fontSize(16)
        .fontColor('#333333')
        .onChange((value: string) => {
          this.onTextChange?.(value); // 直接调用属性传递的回调
        })

      //=================== 右侧删除按钮区域 ===================
      Text('删除')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .borderRadius(16)
        .margin({ left: 8 })
        .fontColor($r('app.color.White'))
        .backgroundColor($r('app.color.Red'))
        .onClick(() => {
          this.onDelete?.(); // 直接调用属性传递的回调
        })
    }
    //=================== 列表项整体样式 ===================
    .width('96%')
    .height(Constants.LIST_ITEM_HEIGHT)
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .backgroundColor(Color.White)
    .borderRadius(Constants.LIST_BORDER_RADIUS)
    .margin({
      left: '3%',
      right: '3%',
      bottom: 12
    })
  }
}

//=================== 待办列表页面模块 ===================
@Component
struct TodoListPage {
  //=================== 状态变量 ===================
  @State totalTasks: TodoItemType[] = [];  // 所有待办任务
  @State newTaskText: string = '';  // 新任务输入框内容

  //=================== 生命周期 ===================
  aboutToAppear() {
    this.totalTasks = TodoData.getData();
  }

  //=================== 业务逻辑方法 ===================
  // 添加新任务
  addTask() {
    if (this.newTaskText.trim() === '') return;

    const newTask: TodoItemType = {
      id: TodoData.getNextId(),
      content: this.newTaskText.trim(),
      isCompleted: false
    };

    this.totalTasks.push(newTask);
    this.newTaskText = '';  // 清空输入框
  }

  // 删除任务
  deleteTask(id: number) {
    this.totalTasks = this.totalTasks.filter(item => item.id !== id);
  }

  // 切换完成状态
  toggleTaskStatus(id: number) {
    this.totalTasks = this.totalTasks.map((item: TodoItemType): TodoItemType => {
      if (item.id === id) {
        return { id: item.id, content: item.content, isCompleted: !item.isCompleted };
      }
      return item;
    });
  }

  // 更新任务文本
  updateTaskText(id: number, newContent: string) {
    this.totalTasks = this.totalTasks.map((item: TodoItemType): TodoItemType => {
      if (item.id === id) {
        return { id: item.id, content: newContent, isCompleted: item.isCompleted };
      }
      return item;
    });
  }

  //=================== 页面构建 ===================
  build() {
    Column({ space: Constants.COLUMN_SPACE }) {
      //=================== 页面标题区域 ===================
      Text('   我的待办清单')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .lineHeight(36)
        .width(Constants.TITLE_WIDTH)
        .margin({ top: 40, bottom: 20 })
        .textAlign(TextAlign.Start)

      //=================== 新增任务输入区域 ===================
      Row({ space: 12 }) {
        TextInput({
          placeholder: '输入新的待办事项',
          text: this.newTaskText
        })
          .onChange((value: string) => {
            this.newTaskText = value;  // 更新输入框内容
          })
          .width('70%')
          .height(40)
          .borderRadius(20)
          .backgroundColor(Color.White)
          .padding({ left: 16, right: 16 })

        Button('添加')
          .width('30%')
          .height(40)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .borderRadius(20)
          .onClick(() => {
            this.addTask();  // 触发添加任务
          })
      }
      .padding({ left: 20, right: 20, bottom: 20 })

      //=================== 待办事项列表区域 ===================
      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.totalTasks, (item: TodoItemType) => {
            // 渲染每个待办事项并绑定事件
            TodoItem({
              todoItem: item,
              // 直接通过属性传递回调（替代链式调用）
              onDelete: () => {
                this.deleteTask(item.id);
              },
              onToggle: () => {
                this.toggleTaskStatus(item.id);
              },
              onTextChange: (content: string) => {
                this.updateTaskText(item.id, content);
              }
            })
          }, (item: TodoItemType) => item.id.toString())
        }
        .width('100%')
        .padding({ bottom: 20 })
      }
      .width('100%')
      .margin({ top: -10 })  // 负边距调整布局
    }
    //=================== 页面整体样式 ===================
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.PAGE_BACKGROUND)
  }
}

export { TodoListPage };