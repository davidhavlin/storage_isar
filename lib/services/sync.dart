import 'package:storage_test/services/storage.dart';
import 'package:signals/signals_flutter.dart';

// class SyncService {
//   Future<List<T>> sync<T>({
//     required String id,
//     required Future<List<T>> Function() fetchData,
//     required Duration interval,
//   }) async {
//     final lastSyncTimestamp = await $storage.getSyncTimestamp(id);
//     final isSyncNeeded = _isSyncNeeded(lastSyncTimestamp, interval);

//     if (isSyncNeeded) {
//       print('Fetching data for: $id');
//       final data = await fetchData();
//       await $storage.saveData<T>(data);
//       await $storage.saveSyncData(id, DateTime.now());
//       return data;
//     } else {
//       print('Using cached data for: $id');
//       return await $storage.getData<T>();
//     }
//   }

//   bool _isSyncNeeded(DateTime? lastSyncTimestamp, Duration interval) {
//     if (lastSyncTimestamp == null) return true;
//     return DateTime.now().difference(lastSyncTimestamp) > interval;
//   }
// }

class SyncService<T> {
  final String id;
  final Future<List<T>> Function() fetchData;
  final Duration interval;
  final Signal<List<T>> data;
  final Signal<bool> isLoading = Signal<bool>(false);

  SyncService({
    required this.id,
    required this.fetchData,
    required this.interval,
    required this.data,
  });

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final lastSyncTimestamp = await $storage.getSyncTimestamp(id);
      final isSyncNeeded = _isSyncNeeded(lastSyncTimestamp);

      if (isSyncNeeded) {
        print('Fetching data for: $id');
        final fetchedData = await fetchData();
        await $storage.saveData<T>(fetchedData);
        await $storage.saveSyncData(id, DateTime.now());
        data.value = fetchedData;
      } else {
        print('Using cached data for: $id');
        final storedData = await $storage.getData<T>();
        data.value = storedData;
      }
    } catch (e) {
      print('Error fetching data for: $id');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refetch() async {
    isLoading.value = true;
    try {
      final fetchedData = await fetchData();
      await $storage.saveData<T>(fetchedData);
      await $storage.saveSyncData(id, DateTime.now());
      data.value = fetchedData;
    } finally {
      isLoading.value = false;
    }
  }

  bool _isSyncNeeded(DateTime? lastSyncTimestamp) {
    if (lastSyncTimestamp == null) return true;
    return DateTime.now().difference(lastSyncTimestamp) > interval;
  }
}

// final $sync = SyncService();
