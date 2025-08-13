import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/transactions/data/models/transaction_isar.dart';
import '../../features/assets/data/models/asset_isar.dart';

class DatabaseService {
  static late Isar _isar;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TransactionIsarSchema, AssetIsarSchema],
      directory: dir.path,
    );
    _initialized = true;
  }

  static Isar get instance {
    if (!_initialized) {
      throw StateError('Database not initialized. Call DatabaseService.initialize() first.');
    }
    return _isar;
  }

  static Future<void> close() async {
    if (_initialized) {
      await _isar.close();
      _initialized = false;
    }
  }
}
