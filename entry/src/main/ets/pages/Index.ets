//Index.ets
import { TomatoClock } from './TomatoClock';
import { TodoListPage } from './TodoListPage';
import { Settings } from './Settings';
import { FontUtils } from '../until/FontUtils';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @StorageLink('globalFontSize') fontSize: number = 16;

  build() {
    Column() {
      //=================== Tabs导航容器 ===================
      Tabs({ barPosition: BarPosition.End }) {
        //=================== 番茄钟页面 - 第一个Tab ===================
        TabContent() {
          TomatoClock()
        }
        .tabBar(this.buildTabBar('番茄钟', 0))

        //=================== 待办清单页面 - 第二个Tab ===================
        TabContent() {
          TodoListPage()
        }
        .tabBar(this.buildTabBar('待办清单', 1))

        //=================== 设置页面 - 第三个Tab ===================
        TabContent() {
          Settings()
        }
        .tabBar(this.buildTabBar('设置', 2))
      }
      .barWidth('100%')
      .barHeight(60)
      .backgroundColor($r('app.color.background_primary'))
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_secondary'))
  }

  //=================== 构建Tab栏的单个项目 ===================
  @Builder buildTabBar(text: string, index: number) {
    Column() {
      // 图标区域
      Image(this.currentIndex === index ?
        $r('app.media.ic_tab_selected') :
        $r('app.media.ic_tab_normal'))
        .width(24)
        .height(24)
        .margin({ bottom: 4 })

      // 文字区域
      Text(text)
        .fontSize(FontUtils.getSmallSize(this.fontSize))
        .fontColor(this.currentIndex === index ?
          $r('app.color.primary_red') :   // 选中状态用红色
          $r('app.color.primary_green') // 未选中状态用绿色
        )
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(50)
    .padding({ top: 5, bottom: 5 })
  }
}