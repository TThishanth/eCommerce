import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String photoURL;
  final String role;
  final String userName;

  User({
    this.id,
    this.email,
    this.photoURL,
    this.role,
    this.userName,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['uid'],
      userName: doc['userName'],
      email: doc['email'],
      photoURL: doc['profilePhoto'],
      role: doc['role'],
    );
  }
}
