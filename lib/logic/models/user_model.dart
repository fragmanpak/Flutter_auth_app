import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  bool? isVerified;
  final String? email;
  String? password;
  UserModel({this.uid, this.email, this.password,this.isVerified});

  Map<String, dynamic> toMap() {
    return {
      'uid' : uid,
      'email': email,
      'password': password,
      'isVerified':isVerified,

    };
  }

  UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        email = doc.data()!["email"],
        isVerified = doc.data()!["isVerified"];


  UserModel copyWith({
    bool? isVerified,
    String? uid,
    String? email,
    String? password,


  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password,
      isVerified: isVerified ?? this.isVerified
    );
  }
}