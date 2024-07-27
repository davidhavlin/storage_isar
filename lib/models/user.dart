import 'package:isar/isar.dart';
import 'package:storage_test/models/address.dart';
import 'package:storage_test/models/company.dart';
import 'package:storage_test/models/geo.dart';

// generate this with `flutter pub run build_runner build`
part 'user.g.dart';

@collection
class User {
  // Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  Id id;

  String name;
  String username;
  String email;
  Address address;
  String phone;
  String website;
  Company company;
  DateTime lastFetched;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
    required this.lastFetched,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      phone: json['phone'] as String,
      website: json['website'] as String,
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
      lastFetched: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': address.toJson(),
      'phone': phone,
      'website': website,
      'company': company.toJson(),
    };
  }
}
