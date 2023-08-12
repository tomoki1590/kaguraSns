import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ReportePage extends StatelessWidget {
  const ReportePage({Key? key, required this.docId}) : super(key: key);
  final String docId;

  @override
  Widget build(
    BuildContext context,
  ) {
    CollectionReference kaguraSNSCollection;
    kaguraSNSCollection =
        FirebaseFirestore.instance.collection('report');
    return CupertinoAlertDialog(
      title: const Text('この投稿を通報しますか？'),
      content: const Text('この投稿は本当に神楽に関していませんか？もしくは無断転載などだと判断されておりますでしょうか'),
      actions: [
        CupertinoDialogAction(
          child: const Text('通報しません'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('通報します'),
          onPressed: () async {
            unawaited(kaguraSNSCollection.add({'docId': docId}));
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
