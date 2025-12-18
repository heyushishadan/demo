import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/shared_preferences_util.dart';
import 'diary_entry.dart';
import 'diary_detail_page.dart';

class Notebook1Page extends StatefulWidget {
  const Notebook1Page({super.key});

  @override
  State<Notebook1Page> createState() => _Notebook1PageState();
}

class _Notebook1PageState extends State<Notebook1Page> {
  final String _cacheKey = 'notebook1_entries';
  bool _isLoading = true;
  List<DiaryEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  // 加载日记列表
  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
    });
    final content = await SharedPreferencesUtil.getString(_cacheKey);
    _entries = DiaryEntry.decodeList(content);
    setState(() {
      _isLoading = false;
    });
  }

  // 保存日记
  Future<void> _saveEntry(DiaryEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      _entries[index] = entry;
    } else {
      _entries.insert(0, entry);
    }
    await SharedPreferencesUtil.setString(_cacheKey, DiaryEntry.encodeList(_entries));
    setState(() {});
  }

  // 删除日记
  Future<void> _deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await SharedPreferencesUtil.setString(_cacheKey, DiaryEntry.encodeList(_entries));
    setState(() {});
  }

  // 新增日记
  void _addEntry() {
    final entry = DiaryEntry.newEntry();
    Get.to(() => DiaryDetailPage(
      entry: entry,
      onSave: _saveEntry,
      onDelete: _deleteEntry,
      isFromNotebook1: true,
    ));
  }

  // 查看/编辑日记
  void _viewEntry(DiaryEntry entry) {
    Get.to(() => DiaryDetailPage(
      entry: entry,
      onSave: _saveEntry,
      onDelete: _deleteEntry,
      isFromNotebook1: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('记事本1 (SharedPreferences)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_add, size: 64.w, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text(
                        '还没有日记，点击右下角按钮添加第一篇吧！',
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadContent,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 8.h),
                        child: ListTile(
                          leading: const Icon(Icons.article),
                          title: Text(
                            entry.title.isEmpty ? '未命名日记' : entry.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            entry.content.isEmpty ? '暂无内容' : entry.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _viewEntry(entry);
                              } else if (value == 'delete') {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('确认删除'),
                                    content: const Text('确定要删除这篇日记吗？'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                          _deleteEntry(entry.id);
                                        },
                                        child: const Text('删除', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('编辑'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('删除'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _viewEntry(entry),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}

