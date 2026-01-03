import 'package:flutter/widgets.dart';

class ScreenSize {
  static double? _screenWidth;
  static double? _screenHeight;

  static double get screenWidth {
    if (_screenWidth == null) {
      throw Exception("Screen width is not initialized.");
    }
    return _screenWidth!;
  }

  static double get screenHeight {
    if (_screenHeight == null) {
      throw Exception("Screen height is not initialized.");
    }
    return _screenHeight!;
  }

  static double get blockSizeHorizontal {
    return screenWidth / 100;
  }

  static double get blockSizeVertical {
    return screenHeight / 100;
  }

  static void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
  }
}
