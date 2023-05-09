import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                            await _firestore
                                .collection('users')
                                .doc(user
                                    .uid) // Use the user's UID as the document ID
                                .set({
                              'name': name,
                              'email': email,
                              'uid': user.uid,
                            });
                          }
                          await _firestore.collection('users').add({
                            'name': name,
                            'email': email,
                            'uid': uid,
                          });
                          const snackBar = SnackBar(
                            content: Text("成功です"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (builder) => const Login()));
                        } on FirebaseAuthException {
                          rethrow;
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
