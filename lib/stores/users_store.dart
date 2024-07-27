import 'package:storage_test/models/user.dart';
import 'package:storage_test/services/api.dart';
import 'package:storage_test/services/persist_signal.dart';
import 'package:storage_test/services/syncable.dart';

class UsersStore extends Syncable {
  static final UsersStore _instance = UsersStore._internal();
  factory UsersStore() {
    return _instance;
  }

  UsersStore._internal()
      : super('users', syncInterval: const Duration(minutes: 1));

  final users = PersistentSignal<User>('users');

  @override
  Future<void> fetchData() async {
    final response = await api.$get<List<dynamic>>('/users');
    users.value = response.map((userData) => User.fromJson(userData)).toList();
  }
}
