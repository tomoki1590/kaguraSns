import 'package:flutter/cupertino.dart';

class Block extends StatefulWidget {
  @override
  State<Block> createState() => _BlockState();
}

class _BlockState extends State<Block> {
  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            // List docList = [];

            // await kaguraSNSCollection.get().then(
            //     (QuerySnapshot querySnapshot) =>
            //         querySnapshot.docs.forEach((doc) {
            //           docList.add(doc.id);
            //         }));
            // print(docList);
            // .add({'kagura': kaguraSNSCollection});
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
