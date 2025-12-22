// pages/Index.ets
import { TomatoClock } from './TomatoClock';
import { TodoListPage } from './TodoListPage';
import { Settings } from './Settings';
@Entry
@Component
struct Index {
  @State currentIndex: number = 0;

  build() {
    Column() {
      // Tabs作为导航容器
      Tabs({ barPosition: BarPosition.End }) {
        // 番茄钟页面 - 第一个Tab
        TabContent() {
          TomatoClock()
        }
        .tabBar(this.buildTabBar('番茄钟', 0))

        // 中间空页面 - 第二个Tab
        TabContent() {
          TodoListPage()
        }
        .tabBar(this.buildTabBar('待办清单', 1))

        // 设置页面 - 第三个Tab
        TabContent() {
          Settings()
        }
        .tabBar(this.buildTabBar('设置', 2))
      }
      .barWidth('100%')
      .barHeight(60)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 构建Tab栏的单个项目
  @Builder buildTabBar(text: string, index: number) {
    Column() {
      if (this.currentIndex === index) {
        // 选中状态
        Image($r('app.media.ic_tab_selected'))
          .width(24)
          .height(24)
        Text(text)
          .fontSize(12)
          .fontColor($r('app.color.Red'))
      } else {
        // 未选中状态
        Image($r('app.media.ic_tab_normal'))
          .width(24)
          .height(24)
        Text(text)
          .fontSize(12)
          .fontColor($r('app.color.Green'))
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(50)
    .padding({ top: 5, bottom: 5 })
  }
}