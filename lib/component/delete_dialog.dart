import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kagura_sns/log/log_in.dart';

class DeleteDialogComponent extends StatelessWidget {
  const DeleteDialogComponent({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  final String email;
  final String password;
  Future<void> reauthenticateAndDeleteUser(
    String email,
    String password,
  ) async {
    final user = FirebaseAuth.instance.currentUser!;
    if (user.email != email) {
      // print('このメールは違うアカウントのものです。');
      return;
    }
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    try {
      final userCredential =
          await user.reauthenticateWithCredential(credential);
      // Delete
      await userCredential.user!.delete();
      // print('User successfully deleted.');
    } on FirebaseAuthException {
      // print('Failed with error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

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
              if (context.mounted) {
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(builder: (builder) => const Login()),
                );
              }
            } catch (e) {
              const snackBar = SnackBar(
                content: Text('ユーザーを削除しました'),
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
          child: const Text('はい'),
        )
      ],
    );
  }
}
