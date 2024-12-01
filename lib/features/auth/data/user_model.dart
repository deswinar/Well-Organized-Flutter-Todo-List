import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? profilePicture;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.profilePicture,
    this.createdAt,
  });

  /// Convert UserModel to Firestore document (Map<String, dynamic>)
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'display_name': displayName,
      'profile_picture': profilePicture,
      'created_at': createdAt ?? DateTime.now(),
    };
  }

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      displayName: data['display_name'],
      profilePicture: data['profile_picture'],
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
    );
  }
}
