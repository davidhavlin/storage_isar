import 'package:signals/signals_flutter.dart';
import 'package:storage_test/models/user.dart';
import 'package:storage_test/services/api.dart';
import 'package:storage_test/services/sync.dart';

class UsersStore {
  static final UsersStore _instance = UsersStore._internal();
  factory UsersStore() => _instance;
  UsersStore._internal() {
    sync = SyncService<User>(
      id: 'users',
      fetchData: () async {
        final response = await api.$get<List<dynamic>>('/users');
        return response.map((userData) => User.fromJson(userData)).toList();
      },
      interval: const Duration(minutes: 1),
      data: users,
    );
  }

  final users = Signal<List<User>>([]);
  late final SyncService<User> sync;

  // Future<void> sync() async {
  //   isLoading.value = true;
  //   final fetchedUsers = await $sync.sync<User>(
  //     id: 'users',
  //     fetchData: fetchUsers,
  //     interval: const Duration(minutes: 1),
  //   );
  //   users.value = fetchedUsers;
  //   isLoading.value = false;
  // }

  // final sync = SyncService<User>(
  //   id: 'users',
  //   fetchData: () async {
  //     final response = await api.$get<List<dynamic>>('/users');
  //     return response.map((userData) => User.fromJson(userData)).toList();
  //   },
  //   interval: const Duration(minutes: 1),
  //   data: users, // We'll explain this in a moment
  // );
}
