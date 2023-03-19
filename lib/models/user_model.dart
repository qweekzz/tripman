import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String? uid;
  final String? phone;
  final String? displayName;
  final String? email;
  String? smsCode;
  String? password;

  Users({
    this.email,
    this.password,
    this.uid,
    this.phone,
    this.displayName,
    this.smsCode,
  });

  Users copyWith({
    String? uid,
    String? phone,
    String? displayName,
    String? email,
    String? password,
    String? smsCode,
  }) {
    return Users(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password ?? this.password,
      smsCode: smsCode ?? this.smsCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'phone': phone,
    };
  }

  Users.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        phone = doc.data()!["phone"],
        displayName = doc.data()!["displayName"],
        email = doc.data()!["email"];
}
