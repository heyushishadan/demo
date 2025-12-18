import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class listPage extends StatefulWidget {
  const listPage({super.key});

  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {
  late List<String> items;
  String? selectedDate; // 1. 定义日期选择结果变量

  @override
  void initState() {
    super.initState();
    items = {
      '周一', '周二', '周三', '周四', '周五', '周六', '周日',
      '周1', '周2', '周3', '周4', '周6', '周5', '周7', '周8',
      '周9', '周10', '周11', '周12', '周13', '周14', '周15',
      '周16', '周17', '周18', '周19', '周20', '周21', '周22',
      '周23', '周24', '周25', '周26', '周27', '周28', '周29',
      '周30', '周31', '周32', '周33', '周四', '周五', '周六',
      '周日', '周一', '周二', '周三', '周四', '周五', '周六', '周日',
      '周一', '周二', '周三', '周四', '周五', '周六', '周日',
    }.toList();
  }

  // 处理排序逻辑
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final String item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  // 点击列表项时触发：显示提示框
  void _onItemTap(String item) {
    final isHappy = item == '周六' || item == '周日';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: Text(isHappy
            ? '今天是$item！嗨皮！骑车！'
            : '今天是$item！要上班了，不嘻嘻！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 3. 实现 buildSelectRow 方法（自定义选择行UI）
  Widget buildSelectRow(BuildContext context, String? value, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 4.w),
          Text(hint, style: TextStyle(fontSize: 14.sp)),
          if (value != null)
            Text(value, style: TextStyle(fontSize: 14.sp, color: Colors.black87))
          else
            Text('未选择', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 2. 修复 Column 布局：移除 Spacer，改用 Padding 控制间距
        title: Row(
          mainAxisSize: MainAxisSize.min, // 限制 Column 高度为内容高度
          children: [
            const Text('ReorderableListView拖拽列表排序'),
            Spacer(),
            GestureDetector(
              onTap: () {
                TDPicker.showDatePicker(
                  context,
                  title: '选择时间',
                  onConfirm: (selected) {
                    setState(() {
                      // 4. 将选择结果赋值给状态变量
                      selectedDate = '${selected['year'].toString().padLeft(4, '0')}'
                          '-${selected['month'].toString().padLeft(2, '0')}'
                          '-${selected['day'].toString().padLeft(2, '0')}';
                    });
                    Navigator.of(context).pop();
                  },
                  dateStart: [1999, 01, 01],
                  dateEnd: [2025, 12, 31],
                  initialDate: [1999, 1, 1],
                );
              },
              // 使用定义的 selectedDate 变量
              child: buildSelectRow(context, selectedDate, '选择时间'),
            ),
          ],
        ),
      ),
      body: ReorderableListView(
        onReorder: _onReorder,
        children: items.map((item) {
          return ListTile(
            key: ValueKey(item),
            title: Text(item),
            onTap: () => _onItemTap(item),
          );
        }).toList(),
      ),
    );
  }
}