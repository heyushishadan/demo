import 'package:demo3/utils/size_extension.dart';
import 'package:flutter/material.dart';

class DraggableDemoPage extends StatefulWidget {
  DraggableDemoPage({super.key});

  @override
  State<DraggableDemoPage> createState() => _DraggableDemoPageState();
}

class _DraggableDemoPageState extends State<DraggableDemoPage> {
  // 记录展开的章节ID
  final Set<String> _expandedChapterIds = {'1'}; // 默认展开第一章
  // 记录选中的目录项ID
  String? _selectedItemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('侧面目录示例'),
        // 移动端可通过按钮控制侧边栏显示（大屏幕默认显示）
        leading: MediaQuery.of(context).size.width < 600
            ? IconButton(
          icon:  Icon(Icons.menu),
          onPressed: () => _toggleDrawer(context),
        )
            : null,
      ),
      // 侧边栏目录（使用Drawer实现）
      drawer: _buildSideCatalog(),
      body: Center(
        child: Column(
          children:[
            _buildContent(),
            // 接收拖拽的目标
            DragTarget<String>(
              onAccept: (data) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("进球了：$data")),
                );
              },
              builder: (context, candidateData, rejectedData) {
                final isDraggingOver = candidateData.isNotEmpty;
                return Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: isDraggingOver ? Colors.green[100] : Colors.grey[100],
                    border: Border.all(
                      color: isDraggingOver ? Colors.green : Colors.grey,
                    ),
                  ),
                  child: Center(child: Text("篮筐")),
                );
              },
            ),

            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 可拖拽组件
                Draggable<String>(
                  data: "篮球", // 传递的数据
                  child: _buildFruitBox("篮球", Colors.red),
                  feedback: _buildFruitBox("篮球", Colors.red.withOpacity(0.5)),
                  childWhenDragging: _buildFruitBox("投篮", Colors.grey[200]!),
                ),

                // 可拖拽组件
                Draggable<String>(
                  data: "排球", // 传递的数据
                  child: _buildFruitBox("排球", Colors.red),
                  feedback: _buildFruitBox("排球", Colors.red.withOpacity(0.5)),
                  childWhenDragging: _buildFruitBox("投篮", Colors.grey[200]!),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  // 封装水果盒子样式
  Widget _buildFruitBox(String name, Color color) {
    return Container(
      width: 120.w,
      height: 120.w,
      color: color,
      child: Center(
        child: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
      ),
    );
  }

  // 构建侧边目录
  Widget _buildSideCatalog() {
    return Drawer(
      width: 280.w,
      child: Column(
        children: [
          DrawerHeader(
            child: Text(
              '目录',
              style: TextStyle(color: Colors.black, fontSize: 20.sp),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: catalogData.length,
              itemBuilder: (context, index) =>
                  _buildCatalogItem(catalogData[index]),
            ),
          ),
        ],
      ),
    );
  }

  // 递归构建目录项（支持章节展开/折叠）
  Widget _buildCatalogItem(CatalogItem item) {
    if (item.isChapter && item.children != null) {
      // 章节项（可展开）
      return ExpansionTile(
        // 控制展开状态
        initiallyExpanded: _expandedChapterIds.contains(item.id),
        onExpansionChanged: (expanded) {
          setState(() {
            if (expanded) {
              _expandedChapterIds.add(item.id);
            } else {
              _expandedChapterIds.remove(item.id);
            }
          });
        },
        // 章节标题样式
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: _selectedItemId == item.id ? Colors.blue : Colors.black87,
          ),
        ),
        // 章节子项
        children: item.children!.map((child) {
          return _buildCatalogItem(child);
        }).toList(),
      );
    } else {
      // 普通目录项（不可展开）
      return ListTile(
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 14.sp,
            color: _selectedItemId == item.id ? Colors.blue : Colors.black87,
          ),
        ),
        // 左侧选中指示器
        leading: _selectedItemId == item.id
            ? const Icon(Icons.arrow_right, color: Colors.blue)
            : null,
        // 点击选中
        onTap: () {
          setState(() {
            _selectedItemId = item.id;
          });
          // 移动端点击后关闭侧边栏
          if (MediaQuery.of(context).size.width < 600) {
            Navigator.pop(context);
          }
        },
      );
    }
  }

  // 构建主内容区域
  Widget _buildContent() {
    // 找到选中的目录项
    final selectedItem = _findCatalogItemById(_selectedItemId);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedItem?.title ?? '请选择目录项',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Text(
              selectedItem != null
                  ? '此处将显示《${selectedItem.title}》的内容...'
                  : '侧边栏中选择一个章节或小节开始阅读',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // 根据ID查找目录项（递归）
  CatalogItem? _findCatalogItemById(String? id) {
    if (id == null) return null;
    for (final item in catalogData) {
      if (item.id == id) return item;
      if (item.isChapter && item.children != null) {
        final found = _findChildItemById(item.children!, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  CatalogItem? _findChildItemById(List<CatalogItem> children, String id) {
    for (final child in children) {
      if (child.id == id) return child;
      if (child.isChapter && child.children != null) {
        final found = _findChildItemById(child.children!, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  // 切换侧边栏显示/隐藏
  void _toggleDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}



// 目录数据模型
class CatalogItem {
  final String id;
  final String title;
  final bool isChapter; // 是否为章节（可展开/折叠）
  final List<CatalogItem>? children; // 子项（仅章节有）

  CatalogItem({
    required this.id,
    required this.title,
    this.isChapter = false,
    this.children,
  });
}


// 模拟目录数据
final List<CatalogItem> catalogData = [
  CatalogItem(
    id: '1',
    title: '第一章：基础介绍',
    isChapter: true,
    children: [
      CatalogItem(id: '1-1', title: '1.1 什么是Flutter'),
      CatalogItem(id: '1-2', title: '1.2 开发环境搭建'),
      CatalogItem(id: '1-3', title: '1.3 第一个Flutter应用'),
    ],
  ),
  CatalogItem(
    id: '2',
    title: '第二章：Widget基础',
    isChapter: true,
    children: [
      CatalogItem(id: '2-1', title: '2.1 StatelessWidget'),
      CatalogItem(id: '2-2', title: '2.2 StatefulWidget'),
      CatalogItem(id: '2-3', title: '2.3 布局Widget'),
    ],
  ),
  CatalogItem(
    id: '3',
    title: '第三章：路由与导航',
    isChapter: true,
    children: [
      CatalogItem(id: '3-1', title: '3.1 基本路由跳转'),
      CatalogItem(id: '3-2', title: '3.2 命名路由配置'),
    ],
  ),
  CatalogItem(id: '4', title: '附录：常用资源', isChapter: false),
];

