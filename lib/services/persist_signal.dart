import 'package:signals/signals_flutter.dart';
import 'package:storage_test/services/storage.dart';

class PersistentSignal<T> extends Signal<List<T>> {
  final String key;

  PersistentSignal(this.key) : super([]) {
    _loadFromCache();
  }

  Future<void> _loadFromCache() async {
    final cachedData = await $storage.getData<T>();
    value = cachedData;
  }

  @override
  set value(List<T> newValue) {
    super.value = newValue;
    _saveToCache(newValue);
  }

  Future<void> _saveToCache(List<T> data) async {
    await $storage.saveData<T>(data);
  }
}
