import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import 'database_helper.dart';

class StorageFactory {
  static StorageService? _instance;

  static StorageService get instance {
    _instance ??= _createStorageService();
    return _instance!;
  }

  static StorageService _createStorageService() {
    if (kIsWeb) {
      return WebStorageService();
    } else {
      return DatabaseHelper();
    }
  }
} 