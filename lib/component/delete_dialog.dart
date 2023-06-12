import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kagura_sns/log/log_in.dart';

class DeleteDialogComponent extends StatelessWidget {
  final String email;
  final String password;
  const DeleteDialogComponent({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  Future<void> reauthenticateAndDeleteUser(
      String email, String password) async {
    User user = FirebaseAuth.instance.currentUser!;
    if (user.email != email) {
      print('このメールは違うアカウントのものです。');
      return;
    }
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    try {
      UserCredential userCredential =
          await user.reauthenticateWithCredential(credential);
      // Delete
      await userCredential.user!.delete();
      print('User successfully deleted.');
    } on FirebaseAuthException catch (e) {
      print('Failed with error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    return AlertDialog(
      title: const Text('アカウントを削除しますか'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('いいえ'),
        ),
        TextButton(
            onPressed: () async {
              try {
                await reauthenticateAndDeleteUser(email, password);
                await user!.delete();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (builder) => const Login()));
              } catch (e) {
                final snackBar = SnackBar(
                  content: Text("ユーザーを削除しました"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (builder) => const Login()),
                  (Route<dynamic> route) => false);
            },
            child: const Text('はい'))
      ],
    );
  }
}
