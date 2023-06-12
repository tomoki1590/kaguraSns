import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ReportePage extends StatelessWidget {
  final String docId;

  ReportePage({Key? key, required this.docId}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    CollectionReference kaguraSNSCollection =
        FirebaseFirestore.instance.collection('report');
    return CupertinoAlertDialog(
      title: Text('この投稿を通報しますか？'),
      content: Text('この投稿は本当に神楽に関していませんか？もしくは無断転載などだと判断されておりますでしょうか'),
      actions: [
        CupertinoDialogAction(
          child: Text('通報しません'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text('通報します'),
          onPressed: () async {
            print('Reporting document: $docId');
            kaguraSNSCollection.add({'docId': docId});
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
