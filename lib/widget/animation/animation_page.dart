import 'package:demo3/utils/size_extension.dart';
import 'package:demo3/widget/animation/animation_ball.dart';
import 'package:demo3/widget/animation/dialog_tip.dart';
import 'package:demo3/widget/animation/expandable_card.dart';
import 'package:demo3/widget/animation/rank_animation_dialog.dart';
import 'package:flutter/material.dart';

class AnimationDemo extends StatefulWidget { // 类名首字母大写（规范）
  const AnimationDemo({super.key}); // 加 const 优化性能

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> {
  bool _isPopupShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('动画页面'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context){
                      return dialogTip(context);
                    }
                    );

                });
              },
              child: const Icon(Icons.question_mark),
            )
          ],
        ),
      ),
      body:Container(
        child: Wrap(
          children: [
            _Button(
              '查看排名变化', 
              ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => RankAnimationDialog(oldRank: 50,
                    newRank: 18,
                    duration: const Duration(seconds: 5),
                  ),))
                  ),

            _Button(
              '展开卡片动画', 
              ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => ExpandableCardDemo()))
              ),
            
            _Button(
              '选择小球', 
              ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => ExpandableBallDemo()))
              ),
          
          ],
        ),
      ), 
    );
  }


  Widget _Button(String title, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}