import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kagura_sns/log/log_in.dart';

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
    } else {
      const Text("ユーザーはログインしていません。");
    }
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text("アカウント"),
      ),
      body: Column(
        children: [
          Center(
            child: Text(currentUid.isEmpty
                ? 'ユーザーはログインしていません。'
                : '現在のUID: $currentUid'),
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (builder) => const Login()));
              },
              child: const Text("ログアウト")),
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
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['email']),
                );
              }),
        ],
      ),
    );
  }
}
