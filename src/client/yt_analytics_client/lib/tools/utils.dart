library utils;

class Utils {
  static bool isDigit(String val) {
    if (val.isEmpty) {
      return true;
    }
    if (val.length > 1) {
      for (var r in val.runes) {
        if (r ^ 0x30 > 9) {
          return false;
        }
      }
      return true;
    } else {
      return val.runes.first ^ 0x30 <= 9;
    }
  }
}
