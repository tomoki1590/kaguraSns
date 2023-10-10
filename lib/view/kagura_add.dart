import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kagura_sns/component/dialog.dart';
import 'package:kagura_sns/home_screen.dart';

class KaguraAdd extends StatefulWidget {
  const KaguraAdd({Key? key}) : super(key: key);

  @override
  State<KaguraAdd> createState() => _KaguraAddState();
}

class _KaguraAddState extends State<KaguraAdd> {
  File? image;
  final picker = ImagePicker();
  List<XFile>? imageList = [];
  String kagura = '';
  String place = '';
  String point = '';
  String uid = '';
  String? imgUrl;

  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  final FirebaseFirestore _kaguraFire = FirebaseFirestore.instance;
  Future<void> getImageFromGallery() async {
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        imageList =
            pickedFiles.map((file) => File(file.path)).cast<XFile>().toList();
      });
    }
  }

  Future<void> setKagura(String kagura) async {
    this.kagura = kagura;
  }

  Future<void> setPlace(String place) async {
    this.place = place;
  }

  Future<void> setPoint(String point) async {
    this.point = point;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              final shouldPost = await showDialog(
                    context: context,
                    builder: (_) {
                      return const AlertDialogComponent();
                    },
                  ) ??
                  false;
              if (shouldPost as bool) {
                final doc = _kaguraFire.collection('kagura').doc();
                if (image != null) {
                  final storage = FirebaseStorage.instance;
                  final task =
                      await storage.ref('kagura/${doc.id}').putFile(image!);
                  imgUrl = await task.ref.getDownloadURL();
                }

                await doc.set({
                  'kagura': kagura,
                  'place': place,
                  'point': point,
                  'imgUrl': imgUrl,
                  'uid': FirebaseAuth.instance.currentUser!.uid,
                });
                if (context.mounted) {
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (builder) => const HomeScreen(),
                    ),
                  );
                }
              }
            },
            label: const Text('投稿'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 6, 6, 6),
            ),
            icon: const Icon(Icons.send),
          ),
        ],
        title: const Text('神楽情報発信', style: TextStyle(color: Colors.red)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: '演目名'),
                    onChanged: setKagura,
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: '場所'),
                    onChanged: setPlace,
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: '推したいポイント'),
                    onChanged: setPoint,
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  DottedBorder(
                    dashPattern: const [2, 1],
                    child: Container(
                      height: 100,
                      width: 100,
                      color: const Color(0xFFE7E7E7),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_enhance, size: 30),
                    onPressed: getImageFromGallery,
                  ),
                ],
              ),
              image != null ? Image.file(image!) : const Text('何も選ばれてませんよ'),
            ],
          ),
        ),
      ),
    );
  }
}
