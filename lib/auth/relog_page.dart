import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/delete_dialog.dart';
import '../component/validate_text.dart';

class ReLoginPage extends StatefulWidget {
  const ReLoginPage({Key? key}) : super(key: key);

  @override
  State<ReLoginPage> createState() => _ReLoginPageState();
}

class _ReLoginPageState extends State<ReLoginPage> {
  String email = '';
  String password = '';
  bool isVisible = false;
  void toggleShowPassword() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  Future<void> setEmail(String email) async {
    this.email = email;
  }

  Future<void> setPassword(String password) async {
    this.password = password;
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    var currentUid = '';

    if (user != null) {
      currentUid = user.uid;
      Text(currentUid);
    } else {
      const Text('ユーザーはログインしていません。');
    }
    return Scaffold(
      appBar: AppBar(title: const Text('アカウント削除 ')),
      body: Center(
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
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) {
                    return DeleteDialogComponent(
                      email: email,
                      password: password,
                    );
                  },
                );
              },
              child: const Text('アカウント削除'),
            ),
          ],
        ),
      ),
    );
  }
}
