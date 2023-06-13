import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Block extends StatelessWidget {
  final String block;
  Block({Key? key, required this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    CollectionReference kaguraBlock =
        FirebaseFirestore.instance.collection('users');

    String currentUid = "";

    if (user != null) {
      currentUid = user.uid;
      Text(currentUid);
    } else {
      const Text("ユーザーはログインしていません。");
    }
    // DocumentReference<Map<String, dynamic>> kaguraUid =
    //     FirebaseFirestore.instance.collection('users').doc("uid");

    return CupertinoAlertDialog(
      title: Text('この投稿者ブロックしますか？'),
      actions: [
        CupertinoDialogAction(
          child: Text('ブロックしません'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text('ブロックします'),
          onPressed: () async {
            kaguraBlock.doc(user!.uid).update({
              'block': FieldValue.arrayUnion([block])
            });
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
