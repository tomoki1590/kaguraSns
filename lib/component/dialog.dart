import 'package:flutter/material.dart';
import 'package:kagura_sns/home_screen.dart';

class AlertDialogComponent extends StatelessWidget {
  const AlertDialogComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('投稿しますか'),
      actions: <Widget>[
        GestureDetector(
          child: TextButton(
            onPressed: () {},
            child: const Text('いいえ'),
          ),
        ),
        GestureDetector(
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (builder) => const HomeScreen()));
              },
              child: const Text('はい')),
        )
      ],
    );
  }
}
