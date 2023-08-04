import 'package:flutter/material.dart';

import 'view/account_tab.dart';
import 'view/kagura_add.dart';
import 'view/kagura_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int indexList = 0;
  static final tab = [
    const KaguraTab(),
    const KaguraAdd(),
    const AccountTab()
  ];

  void _tappedList(int index) {
    setState(() {
      indexList = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tab[indexList],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _tappedList,
        currentIndex: indexList,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: '追加'),  
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: 'アカウント'),
        ],
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
