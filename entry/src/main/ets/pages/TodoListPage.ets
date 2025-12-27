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
      { id: 2, content: '完成Todo页面', isCompleted: false },
      { id: 3, content: '吃个饭', isCompleted: false },
      { id: 4, content: '番茄钟项目', isCompleted: false }
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
  // 改回 @Prop，使用本地状态管理
  @Prop todoItem: TodoItemType;  // 待办事项数据
  @State localIsCompleted: boolean = false;  // 添加本地状态

  //通过属性接收回调函数（替代手动存储的handler）
  onDelete: () => void = () => {};
  onToggle: () => void = () => {};
  onTextChange: (content: string) => void = () => {};

  // 生命周期：初始化本地状态
  aboutToAppear() {
    this.localIsCompleted = this.todoItem.isCompleted;
  }

  // 生命周期：更新时同步
  aboutToUpdate() {
    this.localIsCompleted = this.todoItem.isCompleted;
  }

  //=================== 组件构建 ===================
  build() {
    Row({ space: 12 }) {
      //=================== 左侧复选框区域 ===================
      Column() {
        Stack() {
          Circle()
            .width(20)
            .height(20)
            // 使用本地状态
            .fill(this.localIsCompleted ? $r('app.color.SkyBlue') : $r('app.color.White'))
            .stroke(this.localIsCompleted ? $r('app.color.SkyBlue') : $r('app.color.Gray'))
            .strokeWidth(1.5)
          // 完成状态显示对勾
          if (this.localIsCompleted) {
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
        // console.info('【Debug】Checkbox clicked, item id:', this.todoItem.id); // 复选框按钮日志
        this.localIsCompleted = !this.localIsCompleted;  // 更新本地状态
        this.onToggle?.(); // 调用父组件回调
      })

      //=================== 中间文本编辑区域 ===================
      Text(this.todoItem.content)
        .width('65%')
        .height(32)
        .fontSize(16)
        .fontColor('#333333')
        // 使用本地状态
        .opacity(this.localIsCompleted ? 0.4 : 1)
        .decoration({
          type: this.localIsCompleted ? TextDecorationType.LineThrough : TextDecorationType.None
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
          // console.info('【Debug】Delete button clicked'); // 删除按钮日志
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
  //=================== 新增弹窗状态 ===================
  @State showDeleteDialog: boolean = false;
  @State deletingId: number = -1; // 当前待删除项ID

  //=================== 新增空输入状态 ===================
  @State showEmptyWarning: boolean = false; // 空输入提示控制
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
    if (this.newTaskText.trim() === '') {
      this.showEmptyWarning = true;
      // 1.5秒后自动隐藏提示
      setTimeout(() => {
        this.showEmptyWarning = false;
      }, 1500);
      return;
    }
    const newTask: TodoItemType = {
      id: TodoData.getNextId(),
      content: this.newTaskText.trim(),
      isCompleted: false
    };

    this.totalTasks.push(newTask);
    this.newTaskText = '';  // 清空输入框
  }

  //=================== 修改后的删除方法 ===================
  deleteTask() {
    if (this.deletingId === -1) return;
    this.totalTasks = [...this.totalTasks.filter(item => item.id !== this.deletingId)]; // 使用扩展运算符触发刷新
    this.deletingId = -1;
  }

  // 切换完成状态
  toggleTaskStatus(id: number) {
    // console.info('【Debug】toggleTaskStatus called for id:', id); // 切换查询日志

    // 方法1：使用数组map（当前方式）
    this.totalTasks = this.totalTasks.map((item: TodoItemType): TodoItemType => {
      if (item.id === id) {
        // console.info('【Debug】Found item, toggling from', item.isCompleted, 'to', !item.isCompleted); //状态切换日志
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
      if (this.showEmptyWarning) {
        Text('请输入待办事项内容')
          .fontSize(14)
          .fontColor($r('app.color.Red'))
          .margin({ top: 10 })
          .opacity(this.showEmptyWarning ? 0.9 : 0) // 绑定动态opacity
          .transition({ type: TransitionType.All })
      }
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
            this.newTaskText = value; // 更新输入框内容
          })
          .width('70%')
          .height(40)
          .borderRadius(20)
          .backgroundColor(Color.White)
          .padding({ left: 16, right: 16 })

        Button('添加')
          .width('30%')
          .height(40)
          .backgroundColor($r('app.color.Blue'))
          .fontColor(Color.White)
          .borderRadius(20)
          .onClick(() => {
            this.addTask(); // 触发添加任务
          })
      }
      .padding({ left: 20, right: 20, bottom: 20 })

      //=================== 待办事项列表区域 ===================
      Scroll() {
        // 判断是否有任务，没有则显示空状态提示
        if (this.totalTasks.length === 0) {
          Column() {
            Text('暂无待办事项，点击"添加"创建第一个任务吧～')
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 40 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .height('100%')
        } else {
          Column({ space: 12 }) {
            ForEach(this.totalTasks, (item: TodoItemType) => {
              TodoItem({
                todoItem: item,
                onDelete: () => {
                  this.deletingId = item.id; // 设置待删除ID
                  this.showDeleteDialog = true; // 显示弹窗
                },
                onToggle: () => {
                  console.info('【Debug】Toggle callback called for item:', item.id); //复选框回调日志
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
      }
      .width('100%')
      .layoutWeight(1) // Scroll组件占据父容器剩余的全部空间，防止无法看完所有列表
      .edgeEffect(EdgeEffect.Spring) //弹性滚动
    }
    //=================== 页面整体样式 ===================
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.PAGE_BACKGROUND)
  }
}

export { TodoListPage };