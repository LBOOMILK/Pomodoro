// utils/FontUtils.ets
export class FontUtils {
  // 获取标题字体大小（比正文字体大8）
  static getTitleSize(baseSize: number): number {
    return baseSize + 8;
  }

  // 获取正文字体大小
  static getBodySize(baseSize: number): number {
    return baseSize;
  }

  // 获取小号字体大小（用于按钮、提示等，确保不小于10px）
  static getSmallSize(baseSize: number): number {
    return Math.max(10, baseSize - 2);  // 比正文小2，最小10px
  }

  // 获取超小字体大小（用于辅助文字）
  static getTinySize(baseSize: number): number {
    return Math.max(8, baseSize - 4);  // 比正文小4，最小8px
  }
}