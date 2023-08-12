import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/validate_text.dart';
import '../home_screen.dart';
import 'change_pass_page.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('参画'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: ValidateText.email,
                      autofillHints: const [AutofillHints.email],
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
                    autofillHints: const [AutofillHints.password],
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
                    try {
                      final user = (await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      ))
                          .user;
                      if (user != null) {
                        final snackBar = SnackBar(
                          content: Text('ログインしました${user.email} , ${user.uid}'),
                        );
                        if (context.mounted) {
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (builder) => const HomeScreen(),
                            ),
                          );
                        }

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } on Exception catch (e) {
                      final snackBar = SnackBar(
                        content: Text('エラー発生しました$e'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('ログイン'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (builder) => const PasswordChangePage(),
                        ),
                      );
                    },
                    child: const Text('パスワードを忘れた方はこちら'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (builder) => const SignUp(),
                      ),
                    );
                  },
                  child: const Text('初めての方はこちらから'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
