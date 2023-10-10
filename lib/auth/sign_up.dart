import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../component/validate_text.dart';
import 'disclaimer_page.dart';
import 'log_in.dart';
import 'terms_of_service_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String uid = '';
  bool isVisible = false;
  File? image;
  final picker = ImagePicker();
  String? imgUrl;
  bool _termsFlag = false;
  bool _disclaimerFlag = false;

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
    return;
  }

  void toggleShowPassword() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  Future<void> setName(String name) async {
    this.name = name;
  }

  Future<void> setEmail(String email) async {
    this.email = email;
  }

  Future<void> setPassword(String password) async {
    this.password = password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: getImageFromGallery,
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
                      decoration: const InputDecoration(hintText: 'ユーザーネーム'),
                      onChanged: setName,
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidateText.password,
                      decoration: const InputDecoration(hintText: 'メールアドレス'),
                      onChanged: setEmail,
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
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: toggleShowPassword,
                      ),
                      filled: true,
                      hintText: 'パスワード',
                    ),
                    onChanged: setPassword,
                    obscureText: !isVisible,
                  ),
                ),
                const Text('登録前に下記の事項に目を通してください'),
                Row(
                  children: [
                    Checkbox(
                      value: _termsFlag,
                      onChanged: (value) {
                        setState(() {
                          _termsFlag = !_termsFlag;
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const TermsOfServicePage(),
                          ),
                        );
                      },
                      child: const Text(
                        '利用規約',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _disclaimerFlag,
                      onChanged: (value) {
                        setState(() {
                          _disclaimerFlag = !_disclaimerFlag;
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const DisclaimerPage(),
                          ),
                        );
                      },
                      child: const Text(
                        '免責事項',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_disclaimerFlag == true &&
                        _termsFlag == true &&
                        (name != '')) {
                      if (_formKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential;
                          userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final user = userCredential.user;
                          if (user != null) {
                            final doc = _firestore.collection('users').doc();
                            if (image != null) {
                              final storage = FirebaseStorage.instance;
                              final task = await storage
                                  .ref('users/${doc.id}')
                                  .putFile(image!);
                              imgUrl = await task.ref.getDownloadURL();
                            }
                            await _firestore
                                .collection('users')
                                .doc(user.uid)
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
                          if (context.mounted) {
                            const snackBar = SnackBar(
                              content: Text('新規登録完了です'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (builder) => const Login(),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('このメールアドレスはすでに登録されています'),
                              ),
                            );
                          } else {
                            rethrow;
                          }
                        }
                      }
                    }
                  },
                  child: const Text('新規登録'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
