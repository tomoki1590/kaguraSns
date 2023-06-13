import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kagura_sns/view/dialog/block.dart';
import 'package:kagura_sns/view/dialog/report_page.dart';

class KaguraTab extends StatefulWidget {
  const KaguraTab({Key? key}) : super(key: key);

  @override
  State<KaguraTab> createState() => _KaguraTabState();
}

class _KaguraTabState extends State<KaguraTab> {
  CollectionReference kaguraSNSCollection =
      FirebaseFirestore.instance.collection('kagura');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('神楽', style: TextStyle(color: Colors.red)),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: kaguraSNSCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('エラーが発生しました: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final kaguraList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: kaguraList.length,
            itemBuilder: (BuildContext context, int index) {
              final kagura = kaguraList[index].data() as Map<String, dynamic>;
              return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('エラーが発生しました');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final currentUserDoc =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final blockList = currentUserDoc['block'] != null
                        ? List<dynamic>.from(currentUserDoc['block'])
                        : [];
                    return kagura["uid"] != null &&
                            !blockList.contains(kagura["uid"])
                        ? Card(
                            child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(kagura["uid"])
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('エラーが発生しました');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  final userDoc = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  snapshot.data!.data() as Map<String, dynamic>;
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage:
                                                  userDoc['imgUrl'] != null &&
                                                          userDoc['imgUrl'] !=
                                                              ''
                                                      ? NetworkImage(
                                                          userDoc["imgUrl"])
                                                      : null,
                                              child: userDoc['imgUrl'] !=
                                                          null &&
                                                      userDoc['imgUrl'] != ''
                                                  ? null
                                                  : const Center(
                                                      child: Text(
                                                        '画像がありません',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            Row(
                                              children: [
                                                Text(userDoc["name"]),
                                                IconButton(
                                                  onPressed: () {
                                                    showCupertinoDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return ReportePage(
                                                            docId: kaguraList[
                                                                    index]
                                                                .id,
                                                          );
                                                        });
                                                  },
                                                  icon: Icon(Icons.more_vert),
                                                ),
                                                ElevatedButton(
                                                    child: Text('ブロック'),
                                                    onPressed: () async {
                                                      showCupertinoDialog(
                                                          context: context,
                                                          builder: (_) {
                                                            return Block(
                                                              block:
                                                                  '${kagura["uid"]}',
                                                              onPressed: () {
                                                                setState(() {});
                                                              },
                                                            );
                                                          });
                                                    }),
                                              ],
                                            )
                                          ],
                                        ),
                                        Text("演目:" + kagura['kagura']!),
                                        Text("場所:" + kagura['place']!),
                                        Text("魅力:" + kagura['point']!),
                                        kagura['imgUrl'] != null
                                            ? Image.network(kagura['imgUrl'])
                                            : Text('画像なし')
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : Container();
                  });
            },
          );
        },
      ),
    );
  }
}
