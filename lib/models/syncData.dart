import 'package:isar/isar.dart';

part 'syncData.g.dart';

@collection
class SyncData {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late DateTime timestamp;
}
