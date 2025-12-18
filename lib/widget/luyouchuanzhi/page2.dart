import 'package:demo3/utils/size_extension.dart';
import 'package:demo3/widget/luyouchuanzhi/page1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class acceptPage2 extends StatelessWidget {
  acceptPage2({super.key});

  @override
  Widget build(BuildContext context) {
    String rubbish = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('垃圾桶2'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              rubbish,
              style: TextStyle(fontSize: 16.sp),
            ),
            ElevatedButton(
              onPressed: () {
                Get.off(acceptPage1(),arguments: '脏话');
              },
              child: Text('返回'),
            )
          ],
        ),
      ),
    );
  }
}
