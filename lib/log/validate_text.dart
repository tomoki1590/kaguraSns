class ValidateText {
  static var email;

  static String? password(String? value) {
    //TextFormFieldに値が入されたときだけvalidateする
    if (value != null) {
      String pattern = r'^[a-zA-Z0-9]{6,}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        //正規表現の条件にマッチしていない時だけエラー文を返す
        return '6文字以上の英数字を入力してください';
      }
    }
    return null;
  }
}
