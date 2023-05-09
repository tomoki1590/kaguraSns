import 'package:flutter/material.dart';

import 'view/account_tab.dart';
import 'view/chat_tab.dart';
import 'view/kagura_add.dart';
import 'view/kagura_tab.dart';
import 'view/search_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indexList = 0;
  static final List tab = [
    KaguraTab(),
    KaguraAdd(),
    SearchTab(),
    ChatTab(),
    AccountTab()
  ];

  void _tappedList(int index) {
    setState(() {
      _indexList = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: tab[_indexList],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _tappedList,
          currentIndex: _indexList,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "ホーム"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "追加"),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded), label: "Serch"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "チャット"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded), label: "アカウント"),
          ],
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.black,
        ),
      ),
    );
  }
}
