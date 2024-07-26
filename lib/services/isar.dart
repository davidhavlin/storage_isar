import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storage_test/models/syncData.dart';
import 'package:storage_test/models/user.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();

  factory IsarService() {
    return _instance;
  }

  IsarService._internal();

  late Isar _isar;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [UserSchema, SyncDataSchema],
        directory: dir.path,
      );
      _isInitialized = true;
    }
  }

  Isar get isar {
    if (!_isInitialized) {
      throw StateError('IsarService must be initialized before use');
    }
    return _isar;
  }
}

final isar = IsarService();
