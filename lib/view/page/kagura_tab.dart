import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kagura_sns/view/dialog/block.dart';
import 'package:kagura_sns/view/dialog/report_page.dart';

import '../../model/users/users.dart';
import 'users_service.dart';

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
              final kagura = kaguraList[index].data() as Map<String, Object?>?;
              return FutureBuilder<Users?>(
                future: UsersService().fetchUsers(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<Users?> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return const Text('エラーが発生しました');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final List<String>? blockList;
                  if (snapshot.data!.block != null) {
                    blockList = snapshot.data!.block;
                  } else {
                    blockList = [];
                  }
                  if (kagura!['uid'] == null ||
                      blockList!.contains(kagura['uid'])) {
                    return Container();
                  }
                  return Card(
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(kagura['uid'] as String?)
                          .get(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return const Text('エラーが発生しました');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        final userDoc =
                            snapshot.data!.data() as Map<String, Object?>?;
                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        userDoc!['imgUrl'] != null &&
                                                userDoc['imgUrl'] != ''
                                            ? NetworkImage(
                                                userDoc['imgUrl']! as String,
                                              )
                                            : null,
                                    child: userDoc['imgUrl'] != null &&
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
                                      Text(
                                        userDoc['name']! as String,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showCupertinoDialog<void>(
                                            context: context,
                                            builder: (_) {
                                              return ReportePage(
                                                docId: kaguraList[index].id,
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.more_vert),
                                      ),
                                      ElevatedButton(
                                        child: const Text('ブロック'),
                                        onPressed: () async {
                                          await showCupertinoDialog<void>(
                                            context: context,
                                            builder: (_) {
                                              return Block(
                                                block: '${kagura['uid']}',
                                                onPressed: () {
                                                  setState(() {});
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text('演目:${kagura['kagura']!}'),
                              Text('場所:${kagura['place']!}'),
                              Text('魅力:${kagura['point']!}'),
                              kagura['imgUrl'] != null
                                  ? Image.network(kagura['imgUrl']! as String)
                                  : const Text('画像なし'),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
