import 'dart:convert';

class RegistrationData {
  String name;
  String email;

  RegistrationData({required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  factory RegistrationData.fromMap(Map<String, dynamic> map) {
    return RegistrationData(
      name: map['name'],
      email: map['email'],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory RegistrationData.fromJson(String source) =>
      RegistrationData.fromMap(jsonDecode(source));
}
