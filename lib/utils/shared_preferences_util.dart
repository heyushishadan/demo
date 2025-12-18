import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferences? _prefs;

  // 初始化
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 保存字符串
  static Future<bool> setString(String key, String value) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(key, value);
  }

  // 获取字符串
  static Future<String?> getString(String key) async {
    if (_prefs == null) await init();
    return _prefs!.getString(key);
  }

  // 删除指定key的数据
  static Future<bool> remove(String key) async {
    if (_prefs == null) await init();
    return await _prefs!.remove(key);
  }

  // 清空所有数据
  static Future<bool> clear() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }

  // 检查key是否存在
  static Future<bool> containsKey(String key) async {
    if (_prefs == null) await init();
    return _prefs!.containsKey(key);
  }
}

