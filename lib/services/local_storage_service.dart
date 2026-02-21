import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  final GetStorage _box = GetStorage();

  // Write
  void write(String key, dynamic value) {
    _box.write(key, value);
  }

  // Read
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  // Remove
  void remove(String key) {
    _box.remove(key);
  }

  // Clear all
  void clear() {
    _box.erase();
  }
}