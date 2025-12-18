import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../widget/notebook/diary_entry.dart';

class CacheUtils {
  static const String _cacheKey = 'notebook2_cache';
  // 保留旧常量以便将来切换为落盘；当前未使用
  // static const String _listFile = 'notebook2_entries.json';
  // 会话级缓存：应用运行期间有效，关闭后即丢失
  static List<DiaryEntry> _sessionEntries = [];

  // 保存文本到缓存
  static Future<bool> saveText(String text) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_cacheKey.txt');
      await file.writeAsString(text);
      return true;
    } catch (e) {
      print('保存缓存失败: $e');
      return false;
    }
  }

  // 从缓存读取文本
  static Future<String> getText() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_cacheKey.txt');
      if (await file.exists()) {
        return await file.readAsString();
      }
      return '';
    } catch (e) {
      print('读取缓存失败: $e');
      return '';
    }
  }

  // 删除缓存
  static Future<bool> deleteCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_cacheKey.txt');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('删除缓存失败: $e');
      return false;
    }
  }

  // 检查缓存是否存在
  static Future<bool> cacheExists() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_cacheKey.txt');
      return await file.exists();
    } catch (e) {
      print('检查缓存失败: $e');
      return false;
    }
  }

  // 读取日记列表（会话级，仅内存，不落盘）
  static Future<List<DiaryEntry>> readEntries() async {
    return List<DiaryEntry>.from(_sessionEntries);
  }

  // 写入日记列表（会话级，仅内存，不落盘）
  static Future<bool> writeEntries(List<DiaryEntry> entries) async {
    _sessionEntries = List<DiaryEntry>.from(entries);
    return true;
  }
}
