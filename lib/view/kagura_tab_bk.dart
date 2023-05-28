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
      FirebaseFirestore.instance.collection('users');
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('神楽'),
      ),
      body: Expanded(
        child: Column(
          children: [
            const Text('神楽団情報'),
            const Text('画像とテキストを表示する。'),
            SizedBox(
              height: 300,
              width: 300,
              child: Card(
                  color: Colors.red,
                  child: Column(
                    children: [Text('投稿神楽団:$userID'), const Text('発信情報')],
                  )),
            ),
            StreamBuilder(
              stream: kaguraSNSCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('エラーが発生しました: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                // Map<String, String>? data =
                //     snapshot.data!.data() as Map<String, String>;
                final kaguras = snapshot.data!.docs;
                // return ListTile(title: Text(data['kagura']));
                return Expanded(
                  child: ListView.builder(
                    itemCount: kaguras.length,
                    itemBuilder: (BuildContext context, int index) {
                      final kagura =
                          kaguras[index].data() as Map<String, String>;
                      // if (index != 1) {
                      //   return Container();
                      // }
                      return Card(
                        child: Text(kagura['kagura']!),
                        // child: Text(kagura.data().toString()),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
