import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/users/users.dart';

class UsersService {
  final _fireStore = FirebaseFirestore.instance;

  Future<Users?> fetchUsers() async {
    final snapshots = await _fireStore
        .collection('users')
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .get();
    if (snapshots.exists && snapshots.data() != null) {
      return Users.fromJson(snapshots.data()!);
    }
    return null;
  }
}
