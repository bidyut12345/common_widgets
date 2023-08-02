extension StringExtensions on String {
  String formatMoney({bool forceDecimal = false}) {
    String newText = replaceAll(',', '');
    List<String> chars = newText.split(".").first.split('');
    String newString = '';
    for (int i = chars.length - 1; i >= 0; i--) {
      if ((chars.length - i - 1) % 3 == 0) {
        newString = ',$newString';
      }
      newString = chars[i] + newString;
    }
    if (newString.endsWith(",")) {
      newString = newString.substring(0, newString.length - 1);
    }
    int dotindex = newText.indexOf(".");
    if (dotindex > -1) {
      var tempstra = newText.substring(dotindex + 1, newText.length);
      var tmp2 = tempstra.replaceAll(".", "");
      if (forceDecimal) {
        if (tmp2.isEmpty) {
          newString += ".00";
        } else if (tmp2.length == 1) {
          newString += ".${tmp2}0";
        } else if (tmp2.length == 2) {
          newString += ".$tmp2";
        } else {
          newString += ".${tmp2.substring(0, 2)}";
        }
      } else {
        if (tmp2.length > 2) {
          newString += ".${tmp2.substring(0, 2)}";
        } else {
          newString += ".$tmp2";
        }
      }
    } else {
      if (forceDecimal) newString += ".00";
    }
    return newString;
  }
}
