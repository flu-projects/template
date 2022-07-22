part of utils;

final red = Color(0xFFFF4759);
final black = Colors.black;
final white = Colors.white;
final blue = Color(0xFF0681d0);
final green = Colors.green;
final yellow = Colors.yellow;
final grey = Colors.grey;
final transparent = Colors.transparent;
final mainc = Color(0xFFFFD601);

extension Colours on String {
  Color get rgb => _HexColor(this);
  Color get argb => _HexColor(this);
}

class _HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    final hexNum = int.parse(hexColor, radix: 16);

    if (hexNum == 0) {
      return 0xff000000;
    }

    return hexNum;
  }

  _HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
