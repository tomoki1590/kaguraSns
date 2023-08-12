import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Block extends StatelessWidget {
  const Block({Key? key, required this.block, required this.onPressed})
      : super(key: key);
  final String block;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    CollectionReference kaguraBlock;
    kaguraBlock =
        FirebaseFirestore.instance.collection('users');

    var currentUid = '';

    if (user != null) {
      currentUid = user.uid;
      Text(currentUid);
    } else {
      const Text('ユーザーはログインしていません。');
    }
    // DocumentReference<Map<String, dynamic>> kaguraUid =
    //     FirebaseFirestore.instance.collection('users').doc("uid");

    return CupertinoAlertDialog(
      title: const Text('この投稿者ブロックしますか？'),
      actions: [
        CupertinoDialogAction(
          child: const Text('ブロックしません'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('ブロックします'),
          onPressed: () async {
            await kaguraBlock.doc(user!.uid).update({
              'block': FieldValue.arrayUnion([block])
            });
            onPressed();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
