import 'dart:convert';

class AppUser {
  String id;
  String email;
  String firstName;
  String secondName;

  AppUser({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
