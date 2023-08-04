import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../log/log_in.dart';
import '../log/relog_page.dart';

class AccountEdit extends StatefulWidget {
  const AccountEdit({Key? key}) : super(key: key);

  @override
  State<AccountEdit> createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    String currentUid = '';

    if (user != null) {
      currentUid = user.uid;
      Text(currentUid);
    } else {
      const Text('ユーザーはログインしていません。');
    }
    File? image;
    final picker = ImagePicker();

    Future getImageFromGallery() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final doc = FirebaseFirestore.instance.collection('users').doc();
        image = File(pickedFile.path);

        if (image != null) {
          FirebaseStorage storage = FirebaseStorage.instance;
          final task = await storage.ref('users/${doc.id}').putFile(image!);
          String imgUrl = await task.ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .update({'imgUrl': imgUrl});
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '編集画面',
          style: TextStyle(color: Colors.red),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const Text('画像を選択してください'),
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
                Map<String, String> data =
                    snapshot.data!.data() as Map<String, String>;
                return Column(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          await getImageFromGallery();
                        },
                        child: Center(
                          child: SizedBox(
                            width: 300,
                            height: 300,
                            child: CircleAvatar(
                              backgroundImage:
                                  data['imgUrl'] != null && data['imgUrl'] != ''
                                      ? NetworkImage(data['imgUrl']!)
                                      : null,
                              child:
                                  data['imgUrl'] != null && data['imgUrl'] != ''
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
                        )),
                    const Padding(padding: EdgeInsets.all(10)),
                    Text(data['name']!),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (builder) => const Login()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text('ログアウト')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => ReLoginPage()));
                        },
                        child: const Text('アカウント削除')),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
