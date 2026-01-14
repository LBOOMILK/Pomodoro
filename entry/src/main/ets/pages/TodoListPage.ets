// TodoPage.ets
//=================== 导入模块 ===================
import prompt from '@ohos.prompt';
import { FontUtils } from '../utils/FontUtils';
//=================== 类型定义模块 ===================
// 弹窗响应类型
interface DialogResponse {
  index: number;  // 按钮索引：0表示第一个按钮，1表示第二个按钮
}

// 待办事项数据类型定义
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
  LIST_ITEM_HEIGHT: number;
  LIST_BORDER_RADIUS: number;
}

//=================== 常量配置模块 ===================
const Constants: ConstantsType = {
  FULL_LENGTH: '100%',
  TITLE_WIDTH: '100%',
  COLUMN_SPACE: 16,  // 列间距
  LIST_ITEM_HEIGHT: 72,  // 列表项高度
  LIST_BORDER_RADIUS: 24  // 列表项圆角半径
};

//=================== 数据管理模块 ===================
class TodoData {
  private static nextId: number = 6;
  // 获取初始数据
  static getData(): TodoItemType[] {
    return [
      { id: 1, content: '此为列表示例', isCompleted: false },
      { id: 2, content: '学习ArkTS基础', isCompleted: false },
      { id: 3, content: '吃个饭', isCompleted: true },
      { id: 4, content: '喝个水', isCompleted: true },
      { id: 5, content: '完成番茄钟项目', isCompleted: false }
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
  //使用本地状态管理
  @Prop todoItem: TodoItemType = { id: 0, content: '', isCompleted: false };  // 待办事项数据，添加默认值避免undefined
  // 恢复localIsCompleted本地状态，用于立即更新UI
  @State localIsCompleted: boolean = false;
  // 导入字体工具
  // 注意：组件内不能直接使用StorageLink，需要通过父组件传递
  @Prop fontSize: number = 16;  // 从父组件传递过来
  // 通过属性接收回调函数（替代手动存储的handler）
  onDelete: () => void = () => {};
  onToggle: () => void = () => {};
  onTextChange: (content: string) => void = () => {};

  //=================== 生命周期 ===================
  // 初始化本地状态
  aboutToAppear() {
    this.localIsCompleted = this.todoItem.isCompleted;
  }

  // 更新时同步父组件数据到本地状态
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
            .fill(this.localIsCompleted ? $r('app.color.checkbox_selected') : $r('app.color.checkbox_unselected'))
            .stroke(this.localIsCompleted ? $r('app.color.checkbox_selected') : $r('app.color.checkbox_unselected'))
            .strokeWidth(1.5)
          // 完成状态显示对勾
          if (this.localIsCompleted) {
            Text('✓')
              .fontSize(12)  // 对勾固定大小
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
          }
        }
        .width(24)
        .height(24)
      }
      .onClick(() => {
        // 先更新本地状态，立即显示UI变化
        this.localIsCompleted = !this.localIsCompleted;
        // 然后调用父组件回调，更新全局状态
        this.onToggle?.();
      })

      //=================== 中间文本编辑区域 ===================
      Text(this.todoItem.content)
        .width('65%')
        .height(32)
        .fontSize(FontUtils.getBodySize(this.fontSize))  // 使用正文字体
        .fontColor($r('app.color.text_primary'))
        // 使用本地状态，立即显示UI变化
        .opacity(this.localIsCompleted ? 0.4 : 1)
        .decoration({
          type: this.localIsCompleted ? TextDecorationType.LineThrough : TextDecorationType.None
        })

      //=================== 右侧删除按钮区域 ===================
      Text('删除')
        .fontSize(FontUtils.getSmallSize(this.fontSize))  // 使用小号字体
        .fontWeight(FontWeight.Medium)
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .borderRadius(16)
        .margin({ left: 8 })
        .fontColor($r('app.color.White'))
        .backgroundColor($r('app.color.primary_red'))
        .onClick(() => {
          this.onDelete?.(); // 直接调用属性传递的回调
        })
    }
    //=================== 列表项整体样式 ===================
    .width('96%')
    .height(Constants.LIST_ITEM_HEIGHT)
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(Constants.LIST_BORDER_RADIUS)
    .margin({
      left: '3%',
      right: '3%',
      bottom: 12
    })
    .shadow({
      radius: 8,
      color: $r('app.color.shadow'),
      offsetX: 0,
      offsetY: 2
    })
  }
}

//=================== 待办列表页面模块 ===================
@Component
struct TodoListPage {
  //=================== 状态变量 ===================
  @StorageLink('globalFontSize') fontSize: number = 16;     //动态字体大小
  @State showEmptyWarning: boolean = false;                 // 空输入提示控制
  @State showInformation: boolean = false;                  // 输入成功提示控制
  @State showDuplicateWarning: boolean = false;             // 重复项提示控制
  @State totalTasks: TodoItemType[] = [];                   // 所有待办任务
  @State filteredTasks: TodoItemType[] = [];                // 过滤后的任务列表
  @State newTaskText: string = '';                          // 新任务输入框内容
  @State filterType: string = 'all';  // 筛选类型：all-所有, completed-已完成, active-未完成

  //=================== 生命周期 ===================
  aboutToAppear() {
    this.totalTasks = TodoData.getData();
    // 初始化过滤后的任务列表
    this.updateFilteredTasks();
  }

  //=================== 业务逻辑方法 ===================
  // 更新过滤后的任务列表 - 用于同步totalTasks和filteredTasks
  updateFilteredTasks() {
    // 确保totalTasks是数组
    if (!Array.isArray(this.totalTasks)) {
      this.filteredTasks = [];
      return;
    }
    
    // 根据filterType过滤任务
    switch (this.filterType) {
      case 'completed':
        this.filteredTasks = this.totalTasks.filter(task => task.isCompleted);
        break;
      case 'active':
        this.filteredTasks = this.totalTasks.filter(task => !task.isCompleted);
        break;
      default:
        this.filteredTasks = [...this.totalTasks];
        break;
    }
  }

  //=================== 业务逻辑方法 ===================
  // 添加新任务
  addTask() {
    const taskContent = this.newTaskText.trim();

    // 检查是否为空
    if (taskContent === '') {
      this.showEmptyWarning = true;
      this.showDuplicateWarning = false;
      this.showInformation = false;
      setTimeout(() => { this.showEmptyWarning = false; }, 1500);
      this.newTaskText = '';  //立即清空输入框
      return;
    }

    // 检查是否重复
    const isDuplicate = this.totalTasks.some(task =>
    task.content.toLowerCase() === taskContent.toLowerCase()
    );

    if (isDuplicate) {
      this.showEmptyWarning = false;
      this.showDuplicateWarning = true;
      this.showInformation = false;
      setTimeout(() => { this.showDuplicateWarning = false; }, 1500);
      this.newTaskText = '';  //立即清空输入框
      return;
    }

    // 添加新任务
    const newTask: TodoItemType = {
      id: TodoData.getNextId(),
      content: taskContent,
      isCompleted: false
    };

    // 将push()改为创建新数组，确保触发响应式更新
    this.totalTasks = [...this.totalTasks, newTask];
    this.newTaskText = '';  //立即清空输入框

    // 更新过滤后的任务列表
    this.updateFilteredTasks();

    // 显示成功提示
    this.showEmptyWarning = false;
    this.showDuplicateWarning = false;
    this.showInformation = true;
    setTimeout(() => { this.showInformation = false; }, 1500);
  }

  // 切换完成状态
  toggleTaskStatus(id: number) {
    this.totalTasks = this.totalTasks.map((item: TodoItemType): TodoItemType => {
      if (item.id === id) {
        return { id: item.id, content: item.content, isCompleted: !item.isCompleted };
      }
      return item;
    });
    
    // 更新过滤后的任务列表
    this.updateFilteredTasks();
  }

  // 更新任务文本
  updateTaskText(id: number, newContent: string) {
    this.totalTasks = this.totalTasks.map((item: TodoItemType): TodoItemType => {
      if (item.id === id) {
        return { id: item.id, content: newContent, isCompleted: item.isCompleted };
      }
      return item;
    });
    
    // 更新过滤后的任务列表
    this.updateFilteredTasks();
  }

  //=================== 页面构建 ===================
  build() {
    Column({ space: Constants.COLUMN_SPACE }) {
      //=================== 空输入警告区域 ===================
      if (this.showEmptyWarning) {
        Text('输入框不能为空哦~想想有什么要做的吧~(-v-)')
          .fontSize(FontUtils.getSmallSize(this.fontSize))  // 使用小号字体
          .fontColor($r('app.color.error'))
          .margin({ top: 10 })
          .opacity(this.showEmptyWarning ? 0.9 : 0)
          .transition({ type: TransitionType.All })
      }
      // 重复项警告
      if (this.showDuplicateWarning) {
        Text('这个待办事项已经存在啦，换一个吧~')
          .fontSize(FontUtils.getSmallSize(this.fontSize))  // 使用小号字体
          .fontColor($r('app.color.warning'))  // 使用警告色（橙色）
          .margin({ top: 10 })
          .opacity(this.showDuplicateWarning ? 0.9 : 0)
          .transition({ type: TransitionType.All })
      }
      // 添加成功提示
      if (this.showInformation){
        Text('待办事项已经添加好啦')
          .fontSize(FontUtils.getSmallSize(this.fontSize))  // 使用小号字体
          .fontColor($r('app.color.info'))
          .margin({ top: 10 })
          .opacity(this.showInformation ? 0.9 : 0)
          .transition({ type: TransitionType.All })
      }

      //=================== 页面标题区域 ===================
      Text('   我的待办清单')
        .fontSize(FontUtils.getTitleSize(this.fontSize))  // 使用标题字体
        .fontWeight(FontWeight.Bold)
        .lineHeight(36)
        .width(Constants.TITLE_WIDTH)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 20, bottom: 20 })
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
          .backgroundColor($r('app.color.card_background'))
          .border({
            width: 1,
            color: $r('app.color.separator')
          })
          .placeholderColor($r('app.color.text_tertiary'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(FontUtils.getBodySize(this.fontSize))  // 输入框文字用正文大小
          .padding({ left: 16, right: 16 })

        Button('添加')
          .width('30%')
          .height(40)
          .backgroundColor($r('app.color.primary_blue'))
          .fontColor($r('app.color.White'))
          .fontSize(FontUtils.getSmallSize(this.fontSize))  // 按钮文字用小号
          .borderRadius(20)
          .onClick(() => {
            this.addTask();  // 触发添加任务
          })
      }
      .padding({ left: 20, right: 20, bottom: 10 })

      //=================== 筛选按钮组 ===================
      Row({ space: 8 }) {
        Button('所有')
          .width('30%')
          .height(32)
          .backgroundColor(this.filterType === 'all' ? $r('app.color.primary_blue') : $r('app.color.button_disabled'))
          .fontColor(this.filterType === 'all' ? $r('app.color.White') : $r('app.color.text_secondary'))
          .fontSize(FontUtils.getSmallSize(this.fontSize) - 2)
          .borderRadius(16)
          .onClick(() => {
            this.filterType = 'all';
            // 更新过滤后的任务列表
            this.updateFilteredTasks();
          })

        Button('已完成')
          .width('30%')
          .height(32)
          .backgroundColor(this.filterType === 'completed' ? $r('app.color.primary_blue') : $r('app.color.button_disabled'))
          .fontColor(this.filterType === 'completed' ? $r('app.color.White') : $r('app.color.text_secondary'))
          .fontSize(FontUtils.getSmallSize(this.fontSize) - 2)
          .borderRadius(16)
          .onClick(() => {
            this.filterType = 'completed';
            // 更新过滤后的任务列表
            this.updateFilteredTasks();
          })

        Button('未完成')
          .width('30%')
          .height(32)
          .backgroundColor(this.filterType === 'active' ? $r('app.color.primary_blue') : $r('app.color.button_disabled'))
          .fontColor(this.filterType === 'active' ? $r('app.color.White') : $r('app.color.text_secondary'))
          .fontSize(FontUtils.getSmallSize(this.fontSize) - 2)
          .borderRadius(16)
          .onClick(() => {
            this.filterType = 'active';
            // 更新过滤后的任务列表
            this.updateFilteredTasks();
          })
      }
      .padding({ left: 20, right: 20, bottom: 10 })

      //=================== 待办事项列表区域 ===================
      Scroll() {
        // 使用filteredTasks计算属性获取过滤后的任务列表
        // 判断过滤后的任务列表是否为空，没有则显示空状态提示
        if (this.filteredTasks.length === 0) {
          Column() {
            Text(this.filterType === 'all' ? '暂无待办事项，点击"添加"创建第一个任务吧～' :
              this.filterType === 'completed' ? '暂无已完成的待办事项' : '暂无未完成的待办事项')
              .fontSize(14)
              .fontColor($r('app.color.text_tertiary'))
              .margin({ top: 40 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .height('100%')
        } else {
          Column({ space: 12 }) {
            // 直接遍历过滤后的任务列表，避免条件判断中的渲染问题
            ForEach(this.filteredTasks, (item: TodoItemType) => {
              TodoItem({
                todoItem: item,
                fontSize: this.fontSize,  // 传递字体大小给子组件
                //=================== 删除按钮回调 ===================
                onDelete: () => {
                  const taskIdToDelete: number = item.id;
                  // 显示确认弹窗
                  prompt.showDialog({
                    title: '删除确认',
                    message: '确定要删除该待办事项吗？\n',
                    buttons: [
                      { text: '取消', color: '#007AFF' },
                      { text: '确定', color: '#FF3B30' }
                    ]
                  })
                    .then((data: DialogResponse) => {
                      if (data.index === 1) {  // 确定按钮
                        // 创建新数组更新totalTasks，确保响应式更新
                        this.totalTasks = this.totalTasks.filter(task => task.id !== taskIdToDelete);
                        // 更新过滤后的任务列表
                        this.updateFilteredTasks();
                      }
                    })
                    .catch((error: Error) => {
                      console.error('弹窗显示失败:', error);
                    });
                },
                //=================== 切换完成状态回调 ===================
                onToggle: () => {
                  this.toggleTaskStatus(item.id);
                },
                //=================== 更新文本回调 ===================
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
      .layoutWeight(1)      // 占据剩余空间
      .edgeEffect(EdgeEffect.Spring)  // 弹性滚动
    }
    //=================== 页面整体样式 ===================
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_secondary'))
  }
}
export { TodoListPage };