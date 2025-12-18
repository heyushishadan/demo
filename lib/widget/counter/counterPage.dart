import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';
import 'count_Controller.dart';
import 'package:get/get.dart';


class CounterPage extends StatelessWidget {
  CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('豆哥的功德计数器(Getx版)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '当前功德:',
                  style: TextStyle(fontSize: 16),
                ),
                Obx(() => Text(
                  '${controller.count.value}',
                  style: const TextStyle(fontSize: 16),
                ))
              ],
            ),
            GestureDetector(
              onTap: () {
                controller.increment();
              },
              child: Container(
                child: Image.asset(
                  'assets/images/qiaomuyu.png',
                  width: 80.w,
                  height: 80.w,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                controller.clear();
              },
              child: Container(
                child: Image.asset(
                  'assets/images/qingchu.png',
                  width: 60.w,
                  height: 60.w,
                ),
              ),
            )
          ]
        )
      )
    );
  }
}