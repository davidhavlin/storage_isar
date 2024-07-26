import 'package:isar/isar.dart';
import 'package:storage_test/models/syncData.dart';
import 'package:storage_test/services/isar.dart';

class StorageService {
  late Isar _isar;

  StorageService() {
    _isar = isar.isar;
  }

  Future<void> saveData<T>(List<T> data) async {
    // await _isar.writeTxn(() async {
    //   final collection = _isar.collection<T>();
    //   await collection.clear();
    //   await collection.putAll(data);
    // });

    await _isar.writeTxn(() async {
      for (var item in data) {
        await _isar
            .collection<T>()
            .put(item); // update existing items or insert new ones
      }
    });
  }

  Future<List<T>> getData<T>() async {
    final collection = _isar.collection<T>();
    return await collection.where().findAll();
  }

  Future<void> saveSyncData(String id, DateTime timestamp) async {
    await _isar.writeTxn(() async {
      await _isar.collection<SyncData>().put(SyncData()
        ..key = id
        ..timestamp = timestamp);
    });
  }

  Future<DateTime?> getSyncTimestamp(String id) async {
    final syncData =
        await _isar.collection<SyncData>().where().keyEqualTo(id).findFirst();
    return syncData?.timestamp;
  }
}

final $storage = StorageService();
