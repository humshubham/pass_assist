import 'dart:math';

class PassGenerator {
  static final String ALPHA_CAPS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static final String ALPHA = "abcdefghijklmnopqrstuvwxyz";
  static final String NUMERIC = "0123456789";
  static final String SPECIAL_CHARS = "!@#%^&*_=+-/";

  var random = new Random();

  String generatePassword(int len, String dic) {
    String result = "";
    for (int i = 0; i < len; i++) {
      int index = random.nextInt(dic.length);
      result += dic[index];
    }
    return result;
  }
}
