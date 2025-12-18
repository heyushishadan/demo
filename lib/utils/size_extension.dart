import 'dart:math';

import 'package:flutter/material.dart';

/// 简单版 ScreenUtil，用于支持 SizeExtension 等扩展
/// 这个工具类提供了屏幕适配功能，可以根据设计稿尺寸自动缩放UI元素
class ScreenUtil {
  // 使用单例模式确保全局只有一个实例
  static final ScreenUtil _instance = ScreenUtil._internal();

  // 工厂构造函数，返回单例实例
  factory ScreenUtil() => _instance;

  // 私有命名构造函数，初始化单例
  ScreenUtil._internal();

  // 设计稿的宽度和高度（默认为iPhone X的设计尺寸）
  static late double _designWidth;
  static late double _designHeight;
  
  // 实际屏幕的宽度和高度
  static late double _screenWidth;
  static late double _screenHeight;
  
  // 缩放比例：屏幕尺寸与设计稿尺寸的比例
  static late double _scaleWidth;
  static late double _scaleHeight;
  
  // 标记是否已初始化
  static bool _inited = false;

  /// 初始化 ScreenUtil
  /// 
  /// [context] BuildContext 上下文，用于获取屏幕信息
  /// [designWidth] 设计稿宽度，默认 375px
  /// [designHeight] 设计稿高度，默认 812px
  static void init(
    BuildContext context, {
    double designWidth = 800,
    double designHeight = 1480,
  }) {
    // 获取设备屏幕尺寸
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    
    // 设置设计稿尺寸
    _designWidth = designWidth;
    _designHeight = designHeight;
    
    // 计算缩放比例
    _scaleWidth = _screenWidth / _designWidth;
    _scaleHeight = _screenHeight / _designHeight;
    
    // 标记已完成初始化
    _inited = true;
  }

  // 获取屏幕宽度
  double get screenWidth => _screenWidth;

  // 获取屏幕高度
  double get screenHeight => _screenHeight;

  /// 根据设计稿宽度设置实际宽度
  /// [width] 设计稿上的宽度值
  double setWidth(num width) {
    // 如果未初始化，直接返回原始值
    if (!_inited) return width.toDouble();
    // 按照宽度缩放比例计算实际宽度
    return width * _scaleWidth;
  }

  /// 根据设计稿高度设置实际高度
  /// [height] 设计稿上的高度值
  double setHeight(num height) {
    if (!_inited) return height.toDouble();
    // 按照高度缩放比例计算实际高度
    return height * _scaleHeight;
  }

  /// 设置圆角半径（按宽度比例缩放）
  /// [r] 设计稿上的圆角值
  double radius(num r) {
    if (!_inited) return r.toDouble();
    // 圆角通常按宽度比例缩放
    return r * _scaleWidth;
  }

  /// 设置字体大小（按宽度比例缩放）
  /// [fontSize] 设计稿上的字体大小
  double setSp(num fontSize) {
    if (!_inited) return fontSize.toDouble();
    // 字体大小通常按宽度比例缩放
    return fontSize * _scaleWidth;
  }

  /// 创建垂直间距 SizedBox（按高度适配）
  /// [height] 设计稿上的高度值
  Widget setVerticalSpacing(num height) => SizedBox(height: setHeight(height));

  /// 创建垂直间距 SizedBox（按宽度适配）
  /// [height] 设计稿上的高度值
  Widget setVerticalSpacingFromWidth(num height) =>
      SizedBox(height: setWidth(height));

  /// 创建水平间距 SizedBox（按宽度适配）
  /// [width] 设计稿上的宽度值
  Widget setHorizontalSpacing(num width) => SizedBox(width: setWidth(width));

  /// 创建水平间距 SizedBox（按圆角适配）
  /// [width] 设计稿上的宽度值
  Widget setHorizontalSpacingRadius(num width) =>
      SizedBox(width: radius(width));

  /// 创建垂直间距 SizedBox（按圆角适配）
  /// [height] 设计稿上的高度值
  Widget setVerticalSpacingRadius(num height) =>
      SizedBox(height: radius(height));
}

/// 数值扩展：提供便捷的屏幕适配方法
/// 扩展了 Dart 的 num 类型，使其可以直接调用适配方法
extension SizeExtension on num {
  /// [ScreenUtil.setWidth] 的快捷方式
  /// 将数值按设计稿宽度比例转换为实际宽度
  double get w => ScreenUtil().setWidth(this);

  /// [ScreenUtil.setHeight] 的快捷方式
  /// 将数值按设计稿高度比例转换为实际高度
  double get h => ScreenUtil().setHeight(this);

  /// [ScreenUtil.radius] 的快捷方式
  /// 将数值按设计稿圆角比例转换为实际圆角值
  double get r => ScreenUtil().radius(this);

  /// [ScreenUtil.setSp] 的快捷方式
  /// 将数值按设计稿字体大小比例转换为实际字体大小
  double get sp => ScreenUtil().setSp(this);

  /// 智能字体大小：如果按 sp 适配后比原值更大，则取原值，避免超大屏字体过大
  double get spMin => min(toDouble(), sp);

  /// 已废弃的方法，推荐使用 spMin
  @Deprecated('use spMin instead')
  double get sm => min(toDouble(), sp);

  /// 智能字体大小：取原值和 sp 中更大的一个
  double get spMax => max(toDouble(), sp);

  /// 屏幕宽度的倍数
  /// 例如：0.5.sw 表示屏幕宽度的一半
  double get sw => ScreenUtil().screenWidth * this;

  /// 屏幕高度的倍数
  /// 例如：0.5.sh 表示屏幕高度的一半
  double get sh => ScreenUtil().screenHeight * this;

  /// [ScreenUtil.setHeight] 的快捷 Widget 方式
  /// 返回一个指定高度的 SizedBox
  Widget get verticalSpace => ScreenUtil().setVerticalSpacing(this);

  /// [ScreenUtil.setVerticalSpacingFromWidth] 的快捷 Widget 方式
  /// 返回一个按宽度适配的指定高度的 SizedBox
  Widget get verticalSpaceFromWidth =>
      ScreenUtil().setVerticalSpacingFromWidth(this);

  /// [ScreenUtil.setWidth] 的快捷 Widget 方式
  /// 返回一个指定宽度的 SizedBox
  Widget get horizontalSpace => ScreenUtil().setHorizontalSpacing(this);

  /// [ScreenUtil.radius] 的快捷 Widget 方式
  /// 返回一个按圆角适配的指定宽度的 SizedBox
  Widget get horizontalSpaceRadius =>
      ScreenUtil().setHorizontalSpacingRadius(this);

  /// [ScreenUtil.radius] 的快捷 Widget 方式
  /// 返回一个按圆角适配的指定高度的 SizedBox
  Widget get verticalSpacingRadius =>
      ScreenUtil().setVerticalSpacingRadius(this);
}

/// EdgeInsets 扩展：提供适配的 EdgeInsets
extension EdgeInsetsExtension on EdgeInsets {
  /// 创建按圆角比例适配的 EdgeInsets
  EdgeInsets get r => copyWith(
        top: top.r,
        bottom: bottom.r,
        right: right.r,
        left: left.r,
      );

  /// 创建按宽度比例适配的 EdgeInsets
  EdgeInsets get w => copyWith(
        top: top.w,
        bottom: bottom.w,
        right: right.w,
        left: left.w,
      );

  /// 创建按高度比例适配的 EdgeInsets
  EdgeInsets get h => copyWith(
        top: top.h,
        bottom: bottom.h,
        right: right.h,
        left: left.h,
      );
}

/// BorderRadius 扩展：提供适配的 BorderRadius
extension BorderRaduisExtension on BorderRadius {
  /// 创建按圆角比例适配的 BorderRadius
  BorderRadius get r => copyWith(
        bottomLeft: bottomLeft.r,
        bottomRight: bottomRight.r,
        topLeft: topLeft.r,
        topRight: topRight.r,
      );

  /// 创建按宽度比例适配的 BorderRadius
  BorderRadius get w => copyWith(
        bottomLeft: bottomLeft.w,
        bottomRight: bottomRight.w,
        topLeft: topLeft.w,
        topRight: topRight.w,
      );

  /// 创建按高度比例适配的 BorderRadius
  BorderRadius get h => copyWith(
        bottomLeft: bottomLeft.h,
        bottomRight: bottomRight.h,
        topLeft: topLeft.h,
        topRight: topRight.h,
      );
}

/// Radius 扩展：提供适配的 Radius
extension RaduisExtension on Radius {
  /// 创建按圆角比例适配的 Radius
  Radius get r => Radius.elliptical(x.r, y.r);

  /// 创建按宽度比例适配的 Radius
  Radius get w => Radius.elliptical(x.w, y.w);

  /// 创建按高度比例适配的 Radius
  Radius get h => Radius.elliptical(x.h, y.h);
}

/// BoxConstraints 扩展：提供适配的 BoxConstraints
extension BoxConstraintsExtension on BoxConstraints {
  /// 创建按圆角比例适配的 BoxConstraints
  BoxConstraints get r => copyWith(
        maxHeight: maxHeight.r,
        maxWidth: maxWidth.r,
        minHeight: minHeight.r,
        minWidth: minWidth.r,
      );

  /// 创建按高度-宽度混合比例适配的 BoxConstraints
  BoxConstraints get hw => copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.w,
        minHeight: minHeight.h,
        minWidth: minWidth.w,
      );

  /// 创建按宽度比例适配的 BoxConstraints
  BoxConstraints get w => copyWith(
        maxHeight: maxHeight.w,
        maxWidth: maxWidth.w,
        minHeight: minHeight.w,
        minWidth: minWidth.w,
      );

  /// 创建按高度比例适配的 BoxConstraints
  BoxConstraints get h => copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.h,
        minHeight: minHeight.h,
        minWidth: minWidth.h,
      );
}