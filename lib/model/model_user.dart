import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String image;

  User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
    };
  }
// @override
// String toString() {
//   return 'Dog{id: $id, name: $name, age: $age}';
// }
}