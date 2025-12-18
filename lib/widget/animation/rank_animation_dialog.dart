import 'dart:async';

import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RankAnimationDialog extends StatefulWidget {

  final int oldRank; // 旧排名
  final int newRank; // 新排名
  final Duration duration; // 动画持续时间

  const RankAnimationDialog({
    super.key, 
    required this.oldRank, 
    required this.newRank, 
    this.duration = const Duration(seconds: 5)});

  @override
  State<StatefulWidget> createState() => _RankAnimationDialogState();
}

class _RankAnimationDialogState extends State<RankAnimationDialog>
    with TickerProviderStateMixin {

  Timer? _dismissTimer; //定时器
  int _countdown = 5; //倒计时秒数
  RxBool showCountDown = false.obs; //是否显示倒计时

  bool _isAnimationStarted = false; //是否开始动画
  AnimationController? _mainController; //控制数字滚动的主动画

  //缩放动画
  AnimationController? _scaleController; //控制缩放的动画
  Animation<double>? _scaleAnimation; //缩放动画值

  //背景旋转动画
  AnimationController? _rotateController; //控制旋转的动画

  
  List<int> _randomRanksList = [89, 23, 33, 45, 56, 73, 14, 64]; //中间过渡用的随机排名
  int _maxDigits = 0; //最大数字位数
  int? _lastDisplayRank; //上一次显示的排名

  bool _shouldShowDialog = true; //是否显示弹窗


  @override
  void initState() { 
    super.initState();
    if(widget.oldRank <= 0 || widget.newRank <= 0) {
      _shouldShowDialog = false;
      Future.delayed(Duration.zero, () {
        if(mounted){
          Navigator.pop(context);
        }
      });
      return;
    }

    //初始化缩放动画
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController!, 
      curve: Curves.easeInOut, //有弹性回弹的效果
    );
    _scaleController!.forward(); //开始执行缩放动画

    //初始化旋转动画
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    //计算排名列表数字的最大位数
    final allRanks = [widget.oldRank,..._randomRanksList, widget.newRank];
    _maxDigits = allRanks.fold(0, (max , rank){
      if(rank == null) return max;
      final digits = rank.abs().toString().length;
      return digits > max ? digits : max;
    });

    //将新排名加入随机排名列表，作为结尾
    _randomRanksList.add(widget.newRank!);

    _lastDisplayRank = widget.oldRank;


    //初始化数字滚动主动画
    _mainController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) { 
      if(mounted && _mainController != null && !_isAnimationStarted){
        _isAnimationStarted = true;
        _mainController!.forward(); //开始执行数字滚动动画
      }
    });

    _dismissTimer = Timer(widget.duration, (){
      showCountDown.value = true;
      _startCountDown();
    });


  }

  void _startCountDown(){
    Future.delayed(const Duration(seconds: 1), (){
      if(!mounted) return;
      setState(() {
        _countdown--;
      });
      if(_countdown <= 0){
        if(mounted){
          Navigator.pop(context);
        }
      }else{
        _startCountDown();

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!_shouldShowDialog) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final rankTextStyle = textTheme.displayMedium?.copyWith(
      fontSize: 48.sp,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ) ?? const TextStyle(
      fontSize: 48,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Dialog(
      elevation: 0,
      alignment: Alignment.center,
      insetPadding: EdgeInsets.only(top:160.h),
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation!,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '您的排名已更新',
              style: TextStyle(
                fontSize: 24.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: 220.w,
              height: 220.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  //背景旋转动画
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_rotateController!),
                    child: Image.asset(
                      'assets/images/paiming.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    child:Container(),
                  )
                ],
              ),
            ),
            Obx(
              () => showCountDown.value ? Text(
                ' $_countdown s',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ) : const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildRankContent(TextStyle style){
    final int? oldRank = (widget.oldRank ?? 0) >= 0 ? widget.oldRank : null;
    final int? newRank = (widget.newRank ?? 0) >= 0 ? widget.newRank : null;

    return AnimatedBuilder(
      animation: _mainController! ?? AlwaysStoppedAnimation(0),
      builder:(context, _){
        if(_mainController == null){
          return const SizedBox.shrink();
        }

        //动画未开始时显示旧排名
        if(!_isAnimationStarted || _mainController!.value == 0){
          return const SizedBox.shrink();
        }

        //获取当前动画总进度(0-1)
        final double totalProgress = _mainController!.value;

        //总进度拆分：旧排名->随机1->随机2->...->新排名
        final int segmentCount = _randomRanksList.length + 2;
        final int currentSegment = (totalProgress * segmentCount).floor();

        int startNum,targetNum;
        if(currentSegment == 0){
          //段0：旧排名->随机1
          startNum = oldRank!;
          targetNum = _randomRanksList.isNotEmpty
          ? _randomRanksList[0]!
          : newRank!;
        } else if(currentSegment < _randomRanksList.length){
          //中间段：上一个随机数 -> 当前随机数
          startNum = _randomRanksList[currentSegment - 1];
          targetNum = _randomRanksList[currentSegment];
        }else{
          //最后段：最后一个随机数 -> 新排名
          startNum = _randomRanksList.isNotEmpty ? _randomRanksList.last : newRank!;
          targetNum = newRank!;
        }

        //段内进度（0.0 - 1.0）
        final double segmentProgress = (totalProgress * segmentCount) - currentSegment;

        //创建当前这一小段的数值 tween
        final currentTween = Tween<double>(
          begin: startNum.toDouble(),
          end: targetNum.toDouble(),
        ).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(segmentProgress), 
            curve: Curves.easeOutCubic,
          )
        );

        //当前显示的整数值
        final int currentDisplayedRank = currentTween.value.floor();

        // 数字变化时播放
        

        // 把这个tween 交给数字滚动组件
        // return _NumberRoller()
        return Container();
      }

    );
  }

  //当不需要数字滚动时，直接显示当前整数值
  Widget _buildNumberDisplay(int rank,TextStyle style){
    return _buildShaderMask(
      Row(
        children: [
          if(rank >= 0)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              'No.',
              style: style.copyWith(
                color: Colors.white,
                fontSize: 20.sp
              ),
            ),
          ),
          Text(
            rank >= 0 ? '$rank' : '未上榜',
            style: rank > 100
            ? style.copyWith(
                color: Colors.white,
                fontSize: 25.sp
              )
            : style.copyWith(
                color: Colors.white,
                fontSize: 20.sp
              ),
          )
        ],
      )
    );
  }

  Widget _buildShaderMask(Widget child){
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
         Color(0xFFFDD835),
         Color(0xFFEF6C00),
        ]
      ).createShader(bounds),
        child: child,
    );
  }

  String _titleText(){
    final bool wasRanked = (widget.oldRank ?? 999) <100;
    final bool isRankedNow = (widget.newRank ?? 999) <100;

    if(!wasRanked && isRankedNow) return '恭喜！你已上榜！';
    if(wasRanked && !isRankedNow) return '很遗憾，你未上榜。';
    return '排名变化';
  }

  @override
  void dispose() {
    _mainController?.dispose();
    _scaleController?.dispose();
    _rotateController?.dispose();
    _dismissTimer?.cancel();
    super.dispose();
  }

 
}

 class _NumberRoller extends StatelessWidget {
  final Animation<double> animation;
  final double numberHeight;
  final TextStyle style;
  final int maxDigits;
  final Widget Function(Widget child) shaderBuilder;

  const _NumberRoller({
    required this.animation,
    required this.numberHeight,
    required this.style,
    required this.maxDigits,
    required this.shaderBuilder,
  });

   @override
   Widget build(BuildContext context){
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _){
        final double currentValue = animation.value;
        final int currentNum = currentValue.floor();
        final int nextNum = currentNum + 1;
        final double scrollProgress = currentValue - currentNum; //0-1

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          child: SizedBox(
            width: 100.w,
            height: numberHeight.h,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  top: -scrollProgress * numberHeight.h,
                  child: Column(
                    children: [
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
   }

   Widget _buildDigitLine(int num){
    final String numStr = num.toString().padLeft(maxDigits, '0');
    final int parsed =int.tryParse(numStr) ?? 0;

    return SizedBox(
      height: numberHeight.h,
      width: 100.w,
      child: shaderBuilder(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(parsed >= 0)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'No.',
                style: style.copyWith(
                  color: Colors.white,
                  fontSize: 20.sp
                ),
              ),
            ), 
            Text(
              parsed >= 0 ? '$parsed' : '未上榜',
              style: parsed > 100
              ? style.copyWith(
                  color: Colors.white,
                  fontSize: 25.sp
                )
              : style.copyWith(
                  color: Colors.white,
                  fontSize: 20.sp
                ),
            )
          ],
        )
      ),
    );
   }
  }