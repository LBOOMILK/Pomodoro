// utils/FontUtils.ets

//=================== 字体工具类模块 ===================
export class FontUtils {
  //=================== 主要字体大小方法 ===================

  /**
   * 获取超大标题字体大小（比正文字体大8）
   * 用于：页面主标题
   */
  static getExtraLargeSize(baseSize: number): number {
    return baseSize + 8;
  }

  /**
   * 获取大标题字体大小（比正文字体大4）
   * 用于：用户信息标题
   */
  static getLargeSize(baseSize: number): number {
    return baseSize + 4;
  }

  /**
   * 获取标题字体大小（比正文字体大2）
   * 用于：卡片标题、设置项标题
   */
  static getTitleSize(baseSize: number): number {
    return baseSize + 2;
  }

  /**
   * 获取正文字体大小
   * 用于：主要内容、说明文字
   */
  static getBodySize(baseSize: number): number {
    return baseSize;
  }

  /**
   * 获取小号字体大小（比正文字体小2，最小10px）
   * 用于：按钮文字、辅助说明、提示信息
   */
  static getSmallSize(baseSize: number): number {
    return Math.max(10, baseSize - 2);
  }

  /**
   * 获取超小字体大小（比正文字体小4，最小8px）
   * 用于：版本信息、极小的辅助文字
   */
  static getTinySize(baseSize: number): number {
    return Math.max(8, baseSize - 4);
  }

  /**
   * 获取极小字体大小（固定10px）
   * 用于：按钮上的小字描述
   */
  static getMiniSize(): number {
    return 10;
  }

  /**
   * 获取固定小字体大小（固定12px）
   * 用于：按钮上的描述文字（不受全局字体大小影响）
   */
  static getFixedSmallSize(): number {
    return 12;
  }

  //=================== 特殊用途方法 ===================

  /**
   * 获取按钮上字体大小数字的显示大小
   * 用于：字体大小选择按钮上的"12px"等文字
   */
  static getButtonNumberSize(size: number): number {
    return size === 12 ? 10 : Math.max(10, size - 4);
  }

  /**
   * 检查字体大小是否在有效范围内
   */
  static isValidSize(size: number): boolean {
    return size >= 8 && size <= 32;
  }
}