import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'log_in.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({Key? key}) : super(key: key);

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  String email = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formGlobalKey = GlobalKey();
  Future<void> setEmail(String email) async {
    this.email = email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('パスワード変更')),
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
                    // validator: ValidateText.email,
                    decoration: const InputDecoration(hintText: 'メールアドレス'),
                    onChanged: setEmail,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _auth.sendPasswordResetEmail(email: email);
                    const Text('パスワードリセット用のメールを送信しました');
                  } on Exception catch (e) {
                    final snackBar = SnackBar(
                      content: Text('エラー発生しました$e'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (context.mounted) {
                    await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(builder: (builder) => const Login()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                child: const Text('送信'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
