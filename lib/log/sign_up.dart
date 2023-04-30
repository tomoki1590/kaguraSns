import 'package:flutter/material.dart';
import 'package:kagura_sns/log/log_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規登録"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: "メールアドレス"),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(hintText: "パスワード"),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (builder) => const Login()));
                  },
                  child: const Text('新規登録'))
            ],
          ),
        ),
      ),
    );
  }
}
