import 'package:storage_test/models/user.dart';
import 'package:storage_test/services/api.dart';
import 'package:storage_test/services/persist_signal.dart';
import 'package:storage_test/services/syncable.dart';

class UsersStore extends SyncableStore {
  UsersStore._internal()
      : super(id: 'users', syncInterval: const Duration(minutes: 1));

  final users = PersistentSignal<User>('users');

  @override
  Future<void> fetchData() async {
    final response = await api.$get<List<dynamic>>('/users');
    users.value = response.map((userData) => User.fromJson(userData)).toList();
  }
}

final userStore = UsersStore._internal();
