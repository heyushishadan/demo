import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'diary_entry.dart';

class DiaryDetailPage extends StatefulWidget {
  final DiaryEntry? entry;
  final Function(DiaryEntry) onSave;
  final Function(String) onDelete;
  final bool isFromNotebook1;

  const DiaryDetailPage({
    super.key,
    this.entry,
    required this.onSave,
    required this.onDelete,
    required this.isFromNotebook1,
  });

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DiaryEntry _currentEntry;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry ?? DiaryEntry.newEntry();
    _titleController = TextEditingController(text: _currentEntry.title);
    _contentController = TextEditingController(text: _currentEntry.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveEntry() {
    _currentEntry.title = _titleController.text.trim().isEmpty ? '未命名日记' : _titleController.text.trim();
    _currentEntry.content = _contentController.text;
    _currentEntry.updatedAt = DateTime.now();
    
    widget.onSave(_currentEntry);
    Get.snackbar('成功', '日记已保存', 
        backgroundColor: Colors.green, colorText: Colors.white);
    
    setState(() {
      _isEditing = false;
    });
  }

  void _deleteEntry() {
    Get.dialog(
      AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这篇日记吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              widget.onDelete(_currentEntry.id);
              Get.back(); // 返回列表页
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          // 处理键盘快捷键
          if (event.logicalKey == LogicalKeyboardKey.keyE && 
              HardwareKeyboard.instance.isControlPressed) {
            // Ctrl+E 编辑
            if (!_isEditing) {
              _toggleEdit();
            }
          } else if (event.logicalKey == LogicalKeyboardKey.keyS && 
                     HardwareKeyboard.instance.isControlPressed) {
            // Ctrl+S 保存
            if (_isEditing) {
              _saveEntry();
            }
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            // Esc 取消编辑
            if (_isEditing) {
              setState(() {
                _isEditing = false;
                _titleController.text = _currentEntry.title;
                _contentController.text = _currentEntry.content;
              });
            }
          } else if (event.logicalKey == LogicalKeyboardKey.keyD && 
                     HardwareKeyboard.instance.isControlPressed) {
            // Ctrl+D 删除
            if (!_isEditing) {
              _deleteEntry();
            }
          }
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑日记' : '查看日记'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (!_isEditing) ...[
            IconButton(
              onPressed: _toggleEdit,
              icon: const Icon(Icons.edit),
              tooltip: '编辑 (Ctrl+E)',
            ),
            IconButton(
              onPressed: _deleteEntry,
              icon: const Icon(Icons.delete),
              tooltip: '删除 (Ctrl+D)',
            ),
          ] else ...[
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _titleController.text = _currentEntry.title;
                  _contentController.text = _currentEntry.content;
                });
              },
              icon: const Icon(Icons.close),
              tooltip: '取消 (Esc)',
            ),
            IconButton(
              onPressed: _saveEntry,
              icon: const Icon(Icons.save),
              tooltip: '保存 (Ctrl+S)',
            ),
          ],
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // 标题
             TextField(
               controller: _titleController,
               enabled: _isEditing,
               style: Theme.of(context).textTheme.headlineSmall,
               decoration: InputDecoration(
                 hintText: '输入标题...',
                 border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
                 contentPadding: _isEditing ? EdgeInsets.all(12.w) : EdgeInsets.zero,
               ),
               onChanged: (value) {
                 // 实时更新标题
                 if (_isEditing) {
                   setState(() {
                     _currentEntry.title = value;
                   });
                 }
               },
             ),
            SizedBox(height: 16.h),
            // 更新时间
            Text(
              '更新时间: ${_currentEntry.updatedAt.toString().substring(0, 19)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.h),
             // 内容
             Expanded(
               child: TextField(
                 controller: _contentController,
                 enabled: _isEditing,
                 maxLines: null,
                 expands: true,
                 textAlignVertical: TextAlignVertical.top,
                 decoration: InputDecoration(
                   hintText: '在这里写你的日记...',
                   border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
                   contentPadding: _isEditing ? EdgeInsets.all(12.w) : EdgeInsets.zero,
                 ),
                 onChanged: (value) {
                   // 实时更新内容
                   if (_isEditing) {
                     setState(() {
                       _currentEntry.content = value;
                     });
                   }
                 },
               ),
             ),
          ],
        ),
      ),
      ),
    );
  }
}
