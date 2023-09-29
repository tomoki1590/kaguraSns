class ValidateText {
  // メールアドレスのバリデーション
  String? email(String? value) {
    if (value != null && value.isNotEmpty) {
      const pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
      final regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return '有効なメールアドレスを入力してください';
      }
    }
    return null;
  }

  // パスワードのバリデーション
  static String? password(String? value) {
    if (value != null && value.isNotEmpty) {
      const pattern = r'^[a-zA-Z0-9]{6,}$';
      final regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return '6文字以上の英数字を入力してください';
      }
    }
    return null;
  }
}
