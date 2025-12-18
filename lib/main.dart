import 'package:demo3/widget/animation/animation_page.dart';
import 'package:demo3/widget/counter/count_Controller.dart';
import 'package:demo3/widget/counter/counterPage.dart';
import 'package:demo3/widget/drag_List/page.dart';
import 'package:demo3/widget/drag_and_drop_demo/page.dart';
import 'package:demo3/widget/luyouchuanzhi/page1.dart';
import 'package:demo3/widget/notebook/notebook1_page.dart';
import 'package:demo3/widget/notebook/notebook2_page.dart';
import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('KeyDownEvent') ||
        details.exception.toString().contains('HardwareKeyboard')) {
      return;
    }
    FlutterError.presentError(details);
  };
  builder: (context, child) {
    // 全局初始化屏幕适配，设置自定义设计稿尺寸
    ScreenUtil.init(
      context,
      designWidth: 800,    // 设置您想要的设计稿宽度
      designHeight: 1480,   // 设置您想要的设计稿高度
    );
    return child ?? const SizedBox.shrink();
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '豆哥的demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF18B48E)),
        useMaterial3: true,
      ),
      builder: (context, child) {
        // 全局初始化屏幕适配，只需在这里调用一次
        ScreenUtil.init(context);
        return child ?? const SizedBox.shrink();
      },
      home: const MyHomePage(title: '豆哥的demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());

    // 定义网格中的所有功能按钮
    final List<Widget> gridItems = [
      // 1. 动画演示
      _buildGridItem(
        label: '去动画世界',
        icon: Icons.animation,
        color: Colors.blue,
        onTap: () => Get.to(() => AnimationDemo(), arguments: '动画演示'),
      ),

      // 2. 拖拽列表
      _buildGridItem(
        label: '拖拽列表',
        icon: Icons.drag_handle,
        color: Colors.blue,
        onTap: () => Get.to(() => listPage(), arguments: '可拖拽排序的列表'),
      ),

      // 3. 计数器
      _buildGridItem(
        label: '功德计数器',
        customContent: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text('功德: ${controller.count.value}')),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/muyu.png',
              width: 32.w,
              fit: BoxFit.contain,
            ),
          ],
        ),
        color: Colors.blue,
        onTap: () => Get.to(() => CounterPage()),
      ),

      // 4. 路由传参（垃圾桶）
      _buildGridItem(
        label: '垃圾桶',
        icon: Icons.delete,
        color: Colors.blue,
        onTap: () => Get.to(() => acceptPage1(), arguments: '这是返回的数据'),
      ),

      // 5. 记事本1
      _buildGridItem(
        label: '记事本1',
        icon: Icons.book,
        color: Colors.green,
        onTap: () => Get.to(() => const Notebook1Page()),
      ),

      // 6. 记事本2
      _buildGridItem(
        label: '记事本2',
        icon: Icons.note,
        color: Colors.orange,
        onTap: () => Get.to(() => const Notebook2Page()),
      ),

      // 7. 拖拽
      _buildGridItem(
        label: '拖拽交互',
        icon: Icons.drag_handle,
        color: Colors.orange,
        onTap: () => Get.to(() => DraggableDemoPage()),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      // 网格列表主体
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: GridView.count(
          // 2列网格（可根据屏幕宽度调整）
          crossAxisCount: 2,
          // 列间距
          crossAxisSpacing: 12.w,
          // 行间距
          mainAxisSpacing: 12.h,
          // 网格内边距
          padding: EdgeInsets.all(8.w),
          // 子项宽高比（宽:高 = 1:1.2，稍高一点的矩形）
          childAspectRatio: 1 / 0.4,
          // 网格子项列表
          children: gridItems,
        ),
      ),
    );
  }

  // 网格项通用构建方法（封装样式，减少重复代码）
  Widget _buildGridItem({
    required String label,
    IconData? icon,
    Widget? customContent, // 自定义内容（用于计数器这种特殊项）
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(width: 2.w, color: color),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 优先显示自定义内容，否则显示图标+文字
            if (customContent != null)
              customContent
            else ...[
              if (icon != null)
                Icon(icon, color: color, size: 32.w),
              if (icon != null) SizedBox(height: 32.h),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}