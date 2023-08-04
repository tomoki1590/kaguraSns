import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kagura_sns/log/log_in.dart';
import 'package:kagura_sns/log/validate_text.dart';

class PasswordChangePage extends StatefulWidget {
  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  String email = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formGlobalKey = GlobalKey();
  void setEmail(String email) {
    this.email = email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('パスワード変更')),
      body: Center(
        child: Form(
          key: _formGlobalKey,
          child: Column(
            children: [
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ValidateText.email,
                    decoration: const InputDecoration(hintText: 'メールアドレス'),
                    onChanged: (text) {
                      setEmail(text);
                    },
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await _auth.sendPasswordResetEmail(email: email);
                      print('パスワードリセット用のメールを送信しました');
                    } catch (e) {
                      final snackBar = SnackBar(
                        content: Text('エラー発生しました$e'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (builder) => const Login()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text('送信'))
            ],
          ),
        ),
      ),
    );
  }
}
