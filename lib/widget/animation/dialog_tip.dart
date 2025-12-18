import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';


Widget dialogTip(BuildContext context) {
  bool _isPopupShow = true;

  
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        width: 0.6.sw,
        height: 0.6.sh,
        child: AnimatedPositioned(
            // 控制弹窗的位置动画（使用屏幕高度/宽度换算像素）
            top: _isPopupShow ? 0.25.sh : 0.3.sh,
            left: 0.1.sw,
            right: 0.1.sw,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // 3. 弹窗透明度动画（移到 AnimatedPositioned 内部）
            child: AnimatedOpacity(
              opacity: _isPopupShow ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              // 4. 弹窗内容（隐藏时用 SizedBox.shrink() 占位，避免布局抖动）
              child: _isPopupShow
                  ? Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.w,
                      offset: Offset(0, 4.h),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 自适应高度
                  children: [
                    Icon(
                      Icons.notification_important,
                      color: Colors.blue,
                      size: 48.w,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      '提示弹窗',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '这是用 AnimatedOpacity + AnimatedPositioned 实现的弹窗，点击遮罩或关闭按钮即可关闭',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => setState(() => _isPopupShow = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                      ),
                      child: const Text('关闭'),
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),
      );
      },
  );
}
