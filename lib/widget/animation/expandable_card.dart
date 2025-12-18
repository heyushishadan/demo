import 'dart:async';
import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';


class ExpandableCardDemo extends StatefulWidget{
  
  @override
  _ExpandableCardDemoState createState() => _ExpandableCardDemoState();

}

class _ExpandableCardDemoState extends State<ExpandableCardDemo> {

  bool _isExpanded = false;
  int count = 0;
  Timer? _timer; // 定时器（用于销毁，避免内存泄漏）
  //定义坐标

  late AnimationController _controller;
  late Animation<int> _colorAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<double> _positionXAnimation;
  late Animation<double> _positionYAnimation;

  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    // 启动定时器：每1秒执行一次回调
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        count++; // 核心：每秒数字+1
        _isExpanded = !_isExpanded;
      });
    });
  }

  @override
  void dispose() {
    // 页面销毁时取消定时器，否则会内存泄漏
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('可展开卡片'),),
      body: Center(
        child: Column(
          children: [
            _buildAnimatedCard(_isExpanded, count),
            _buildAnimatedCard(!_isExpanded, count-1),
            _buildAnimatedCard(_isExpanded, count),
            _buildAnimatedCard(!_isExpanded, count-1),
            _buildAnimatedCard(_isExpanded, count),
          ],
        )
      ),
    );
  }


  Widget _buildAnimatedCard(bool isExpanded ,int count ){
    return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut, // 缓动曲线
            width: isExpanded ? 100.w : 50.w,
            height: isExpanded ? 100.w : 50.w,
            decoration: BoxDecoration(
              color: colors[count % colors.length],
              borderRadius: BorderRadius.circular(isExpanded ? 50.w : 25.w),
            ),
            child: Positioned(

              child: Center(
              child: Text(
              isExpanded ? '大' : '小',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            ),
            )
          );
          
  }

  


}
