import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class acceptPage1 extends StatelessWidget {
  const acceptPage1({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取传递的参数
    final String arguments = Get.arguments ?? '没有传递数据';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('接收页面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '接收到的数据: $arguments',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                Get.back(result: '这是从页面1返回的数据');
              },
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
}