// ignore_for_file: avoid_print

import 'package:signals/signals_flutter.dart';
import 'package:storage_test/services/storage.dart';

abstract class SyncableStore {
  final String id;
  final Signal<bool> isLoading = Signal<bool>(false);
  final Duration syncInterval;

  SyncableStore({
    required this.id,
    this.syncInterval = const Duration(minutes: 30),
  });

  Future<void> fetchData();

  Future<void> sync({bool force = false}) async {
    if (isLoading.value || !await isSyncNeeded(force)) return;

    isLoading.value = true;
    try {
      print('Syncing data for $id');
      await fetchData();
      await updateSyncTimestamp();
    } catch (e) {
      // Handle or rethrow the error as needed
      print('Error syncing data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refetch() async {
    sync(force: true);
  }

  Future<bool> isSyncNeeded(bool force) async {
    if (force) return true;

    final lastSync = await getLastSyncTimestamp();
    if (lastSync == null) return true;

    if (DateTime.now().difference(lastSync) < syncInterval) {
      print('Skipping sync for $id');
      return false;
    }

    return true;
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    return await $storage.getSyncTimestamp(id);
  }

  Future<void> updateSyncTimestamp() async {
    await $storage.saveSyncData(id, DateTime.now());
  }
}
