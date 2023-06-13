import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kagura_sns/view/account_edit.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String currentUid = "";

    if (user != null) {
      currentUid = user.uid;
      Text(currentUid);
    } else {
      const Text("ユーザーはログインしていません。");
    }
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "アカウント",
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const AccountEdit()));
              },
              label: Text('設定'),
              icon: const Icon(
                Icons.settings,
                color: Colors.red,
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(currentUid.isEmpty ? 'ユーザーはログインしていません。' : ''),
            ),
            const Divider(),
            StreamBuilder(
                stream: usersCollection.doc(currentUid).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('エラーが発生しました: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CircleAvatar(
                          backgroundImage:
                              data['imgUrl'] != null && data['imgUrl'] != ''
                                  ? NetworkImage(data['imgUrl'])
                                  : null,
                          child: data['imgUrl'] != null && data['imgUrl'] != ''
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
                      ),
                      ListTile(
                        title: Text(data['name']),
                        subtitle: Text(data['email']),
                      ),
                      const Divider(),
                      const Text("これまでに投稿したもの"),
                      Card(
                        shadowColor: Colors.black,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('kagura')
                              .where('uid', isEqualTo: currentUid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('エラーが発生しました: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (snapshot.data == null) {
                              return const Text("データがありません");
                            }

                            final kaguraList = snapshot.data!.docs;

                            if (kaguraList.isEmpty) {
                              return const Text("投稿がありません");
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: kaguraList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final kagura = kaguraList[index].data()
                                    as Map<String, dynamic>;
                                return Card(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Text(kagura['kagura']!),
                                        Text(kagura['point']!),
                                        Text(kagura['place']!),
                                        kagura['imgUrl'] != null
                                            ? Image.network(kagura['imgUrl'])
                                            : const Text("画像なし"),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
