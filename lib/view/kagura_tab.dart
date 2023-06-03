import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KaguraTab extends StatefulWidget {
  const KaguraTab({Key? key}) : super(key: key);

  @override
  State<KaguraTab> createState() => _KaguraTabState();
}

class _KaguraTabState extends State<KaguraTab> {
  CollectionReference kaguraSNSCollection =
      FirebaseFirestore.instance.collection('kagura');
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('神楽'),
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
              return Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      children: [
                        kagura["uid"] != null
                            ? FutureBuilder<DocumentSnapshot>(
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
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(userDoc["imgUrl"]),
                                        ),
                                        Text(userDoc["name"])
                                      ],
                                    ),
                                  );
                                })
                            : const Text("不正な投稿データです"),
                        Text("演目:" + kagura['kagura']!),
                        Text("場所:" + kagura['place']!),
                        Text("魅力:" + kagura['point']!),
                        kagura['imgUrl'] != null
                            ? Image.network(kagura['imgUrl'])
                            : const Text(
                                "null",
                                style: TextStyle(fontSize: 100),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
