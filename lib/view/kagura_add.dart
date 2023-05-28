import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kagura_sns/component/dialog.dart';

class KaguraAdd extends StatefulWidget {
  const KaguraAdd({Key? key}) : super(key: key);

  @override
  State<KaguraAdd> createState() => _KaguraAddState();
}

class _KaguraAddState extends State<KaguraAdd> {
  File? image;
  final picker = ImagePicker();
  List<XFile>? imageList = [];
  String kagura = "";
  String place = "";
  String point = "";
  String uid = "";
  String? imgUrl;

  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  final FirebaseFirestore _kaguraFire = FirebaseFirestore.instance;

  // Future getImageFromCamera() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     if (pickedFile != null) {
  //       image = File(pickedFile.path);
  //     }
  //   });
  // }

  // void getImages() async {
  //   final List<XFile>? selectedImages = await picker.pickMultiImage();
  //   if (selectedImages!.isNotEmpty) {
  //     imageList!.addAll(selectedImages);
  //   }
  // }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void setKagura(String kagura) {
    this.kagura = kagura;
  }

  void setPlace(String place) {
    this.place = place;
  }

  void setPoint(String point) {
    this.point = point;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () async {
                final doc = _kaguraFire.collection('kagura').doc();
                if (image != null) {
                  FirebaseStorage storage = FirebaseStorage.instance;
                  final task =
                      await storage.ref('kagura/${doc.id}').putFile(image!);
                  imgUrl = await task.ref.getDownloadURL();
                }

                await doc.set({
                  'kagura': kagura,
                  'place': place,
                  'point': point,
                  'imgUrl': imgUrl,
                  "uid": FirebaseAuth.instance.currentUser!.uid,
                });
                showDialog(
                    context: context,
                    builder: (_) {
                      return const AlertDialogComponent();
                    });
              },
              child: const Text('発信！！'))
        ],
        title: const Text('神楽情報発信'),
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
                    decoration: const InputDecoration(hintText: "演目名"),
                    onChanged: (text) {
                      setKagura(text);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: "場所"),
                    onChanged: (text) {
                      setPlace(text);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: "推したいポイント"),
                    onChanged: (text) {
                      setPoint(text);
                    },
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
                    onPressed: () {
                      getImageFromGallery();
                    },
                  ),
                ],
              ),
              image != null ? Image.file(image!) : const Text("何も選ばれてませんよ")
            ],
          ),
        ),
      ),
    );
  }
}
