import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kagura_sns/log/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'validate_text.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String email = "";
  String password = "";
  String uid = "";
  bool isVisible = false;
  File? image;
  final picker = ImagePicker();
  String? imgUrl;

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void toggleShowPassword() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void setName(String name) {
    this.name = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規登録"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    getImageFromGallery();
                  },
                  child: CircleAvatar(
                    foregroundImage: image == null ? null : FileImage(image!),
                    radius: 50,
                    child: const Icon(Icons.add),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(hintText: "ユーザーネーム"),
                      onChanged: (text) {
                        setName(text);
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
                      validator: ValidateText.email,
                      decoration: const InputDecoration(hintText: "メールアドレス"),
                      onChanged: (text) {
                        setEmail(text);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ValidateText.password,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(isVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            toggleShowPassword();
                          },
                        ),
                        filled: true,
                        hintText: 'パスワード'),
                    onChanged: (text) {
                      setPassword(text);
                    },
                    obscureText: !isVisible,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          User? user = userCredential.user;
                          if (user != null) {
                            final doc = _firestore.collection('users').doc();
                            if (image != null) {
                              FirebaseStorage storage =
                                  FirebaseStorage.instance;
                              final task = await storage
                                  .ref('users/${doc.id}')
                                  .putFile(image!);
                              imgUrl = await task.ref.getDownloadURL();
                            }
                            await _firestore
                                .collection('users')
                                .doc(user
                                    .uid) 
                                .set({
                              'name': name,
                              'email': email,
                              'uid': user.uid,
                              'imgUrl': imgUrl,
                            });
                          }
                          await _firestore.collection('users').add({
                            'name': name,
                            'email': email,
                            'uid': uid,
                            'imgUrl': imgUrl,
                          });
                          const snackBar = SnackBar(
                            content: Text("成功です"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (builder) => const Login()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "email-already-in-use") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("このメールアドレスはすでに登録されています"),
                              ),
                            );
                          } else {
                            rethrow;
                          }
                        }
                      }
                    },
                    child: const Text("新規登録"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
