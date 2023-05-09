import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FirebaseFirestore _kaguraFire = FirebaseFirestore.instance;

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  void getImages() async {
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageList!.addAll(selectedImages);
    }
  }

  Future getImageFromGallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      } else {
        print('No image was selected.');
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
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
                await _kaguraFire.collection('kaguraSNS').add({
                  'kagura': kagura,
                  'place': place,
                  'point': point,
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
      body: Center(
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
                    getImages();
                  },
                ),
              ],
            ),
            const Text('helloっっs'),
          ],
        ),
      ),
    );
  }
}
