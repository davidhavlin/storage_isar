import 'package:storage_test/services/persist_signal.dart';
import 'package:storage_test/services/storage.dart';
import 'package:signals/signals_flutter.dart';

class SyncService<T> {
  final String id;
  final Future<List<dynamic>> Function() fetchData;
  final Duration interval;
  final Signal<bool> isLoading = Signal<bool>(false);
  final PersistentSignal<T> data;
  final T Function(Map<String, dynamic>) fromJson;

  SyncService({
    required this.id,
    required this.fetchData,
    required this.fromJson,
    required this.interval,
  }) : data = PersistentSignal<T>(id);

  Future<bool> isSyncNeeded(bool force) async {
    if (force) return true;

    final lastSyncTimestamp = await $storage.getSyncTimestamp(id);
    if (lastSyncTimestamp == null) return true;

    if (DateTime.now().difference(lastSyncTimestamp) < interval) {
      print('Skipping sync for $id');
      return false;
    }

    return true;
  }

  Future<void> fetch({bool force = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final syncing = await isSyncNeeded(force);

      if (syncing) {
        print('Fetching data for: $id');
        final res = await fetchData();

        if (res.isNotEmpty) {
          data.value = res.map<T>((item) => fromJson(item)).toList();

          // await $storage.saveData<T>(data.value);
          await $storage.saveSyncData(id, DateTime.now());
        }
      } else {
        print('Using cached data for: $id');
        // final storedData = await $storage.getData<T>();
        // data.value = storedData;
      }
    } catch (e) {
      print('Error fetching data for: $id');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refetch() async {
    fetch();
  }
}
