import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';

/// 小球沿着屏幕边缘运动，每绕一圈向内缩一圈，直到运动到屏幕中心
class ExpandableBallDemo extends StatefulWidget {
  @override
  _ExpandableBallDemoState createState() => _ExpandableBallDemoState();
}

class _ExpandableBallDemoState extends State<ExpandableBallDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// 当前已经完成的圈数（向内缩了多少圈）
  int _lap = 0;

  bool isComplete = false;

  /// 每一圈向内缩进的距离（可以按需调整）
  late final double _shrinkStep;

  /// 小球尺寸
  late final double _ballSize;

  @override
  void initState() {
    super.initState();

    _shrinkStep = 40.w;
    _ballSize = 40.w;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // 一圈所需时间
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if(isComplete){
            // 一圈结束，向外缩一圈
            setState(() {
              _lap--;
            });
          }else{
            // 一圈结束，向内缩一圈
            setState(() {
              _lap++;
            });
          }
          
          _controller.forward(from: 0);
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// movement_position：根据当前进度和圈数，计算小球在屏幕上的位置
  Offset movementPosition(double t) {
    final screenWidth = ScreenUtil().screenWidth;
    final screenHeight = ScreenUtil().screenHeight;

    // 当前这一圈可运动的有效矩形区域（四周分别缩进 _lap * _shrinkStep）
    final left = _lap * _shrinkStep;
    final top = _lap * _shrinkStep;
    final right = screenWidth - _lap * _shrinkStep - _ballSize;
    final bottom = screenHeight - _lap * _shrinkStep - _ballSize-50;

    // 如果已经缩到（或超过）中心，就固定在中心
    if (right <= left || bottom <= top) {
      isComplete = true;
    }
    if (_lap ==0) {
      isComplete = false;
    }

    final width = right - left;
    final height = bottom - top;
    final perimeter = 2 * (width + height);

    // t ∈ [0,1]，映射到当前矩形周长上的距离
    final distance = t * perimeter;

    // 分四段：上、右、下、左
    if (distance <= width) {
      // 顶边：从左到右
      return Offset(left + distance, top);
    } else if (distance <= width + height) {
      // 右边：从上到下
      final d = distance - width;
      return Offset(right, top + d);
    } else if (distance <= width + height + width) {
      // 底边：从右到左
      final d = distance - width - height;
      return Offset(right - d, bottom);
    } else {
      // 左边：从下到上
      final d = distance - width - height - width;
      return Offset(left, bottom - d);
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = movementPosition(_controller.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text('小球螺旋运动'),
      ),
      body: Stack(
        children: [
          // 小球
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Container(
              width: _ballSize,
              height: _ballSize,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
