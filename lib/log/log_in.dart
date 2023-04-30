import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home_screen.dart';
import 'sign_up.dart';
import 'validate_text.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;
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

  Future<void> signInWithGogle() async {
    final googleUser =
        await GoogleSignIn(scopes: ['profile', 'email']).signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("入団"),
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
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(onPressed: () {}, child: const Text('ログイン')),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => const SignUp()));
                      },
                      child: const Text("初めての方はこちらから")),
                ),
                SignInButton(Buttons.Google, text: "Googleログイン",
                    onPressed: () async {
                  await signInWithGogle();

                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => true);
                  }
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.Apple,
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.Email,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
