import 'package:storage_test/models/user.dart';
import 'package:storage_test/services/api.dart';
import 'package:storage_test/services/persist_signal.dart';
import 'package:storage_test/services/sync.dart';

class UsersStore {
  static final UsersStore _instance = UsersStore._internal();
  factory UsersStore() => _instance;

  UsersStore._internal() {
    // sync = SyncService<User>(
    //   id: 'users',
    //   fetchData: () => api.$get<List<dynamic>>('/users'),
    //   interval: const Duration(minutes: 1),
    //   data: users,
    // );
  }

  // late final SyncService<User> sync;

  final sync = SyncService<User>(
    id: 'users',
    // fetchData: () async {
    //   final res = await api.$get<List<dynamic>>('/users');
    //   return res.map((userData) => User.fromJson(userData)).toList();
    // },
    fetchData: () => api.$get<List<dynamic>>('/users'),
    fromJson: User.fromJson,
    interval: const Duration(minutes: 1),
  );

  PersistentSignal<User> get users => sync.data;
}
