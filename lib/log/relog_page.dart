import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kagura_sns/log/validate_text.dart';

import '../component/delete_dialog.dart';

class ReLoginPage extends StatefulWidget {
  @override
  State<ReLoginPage> createState() => _ReLoginPageState();
}

class _ReLoginPageState extends State<ReLoginPage> {
  String email = "";
  String password = "";
  bool isVisible = false;
  void toggleShowPassword() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String currentUid = "";

    if (user != null) {
      currentUid = user.uid;
      Text(currentUid);
    } else {
      const Text("ユーザーはログインしていません。");
    }
    return Scaffold(
      appBar: AppBar(title: Text("アカウント削除 ")),
      body: Center(
        child: Column(
          children: [
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
                      icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off),
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
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return DeleteDialogComponent(
                            email: email, password: password);
                      });
                },
                child: const Text('アカウント削除')),
          ],
        ),
      ),
    );
  }
}
