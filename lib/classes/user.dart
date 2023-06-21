// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:server_demo/db_model.dart';
import 'package:server_demo/services/database.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User extends DBModel<User> {
  String? email;
  String? firstName;
  String? lastName;
  String? password;

  User({this.email, this.firstName, this.lastName, this.password})
      : super(database.userCollection);

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        email: json['email'] as String,
      )
        ..id = json['_id']
        ..password = json['password'] as String?;

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('_id', id);
    val['firstName'] = firstName;
    val['lastName'] = lastName;
    val['email'] = email;
    val['password'] = password;
    return val;
  }

  setPassword(String newpassword) {
    password = DBCrypt().hashpw(newpassword, new DBCrypt().gensalt());
  }

  @override
  User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}
