import 'package:flutter/material.dart';

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('免責事項'),
      ),
      body: const Text(
        ''' ※アプリをご利用の際の通信料は、お客さまのご負担となります。
なお、本アプリケーションは、以下の事項を確認し、同意いただいたうえでご利用下さい。
本アプリケーションの利用をもって、本免責事項に同意いただいたものとみなします。
本アプリケーションのダウンロードおよびご利用については、利用者自身の責任において行われるものとします。
当方は、利用者の本サービスの利用環境について一切関与せず、また一切の責任を負いません。
当方は、本アプリケーションを使用することによって生じた、いかなる損害（有形無形に関わりなく）に対して責任を負いません。
お客さまご自身の責任においてご利用いただきますようお願いいたします。
当方は、利用者に対し、本アプリケーションにおいて提供するすべての情報について、その正確性、有用性、最新性、適切性等、その内容について何ら法的保証をするものではありません。
本アプリケーションの内容・情報等は、予告なく変更されることがあります。
本規定は、予告なく内容を変更させて頂く場合があります。''',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
