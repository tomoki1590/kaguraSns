import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/users/users.dart';

class FireStore {
  FireStore({this.uid});
  final String? uid;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future savingUserData(String name, String email) async {
    final user = Users(
      uid: uid!,
      name: name,
      email: email,
    );
    print("$uid+desu");

    //await userCollection.doc(uid).set(user.toFirestore());
    return await userCollection.doc(uid).set({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
    });
  }
}
