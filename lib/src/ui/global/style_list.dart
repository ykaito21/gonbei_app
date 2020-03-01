import 'package:flutter/material.dart';

class StyleList {
  static const baseTitleTextStyle = const TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w900,
  );

  static const baseSubtitleTextStyle = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w900,
  );

  static const smallBoldTextStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w900,
  );

  static const removePadding = const EdgeInsets.all(0.0);

  static const allPadding10 = const EdgeInsets.all(10.0);

  static const verticalPadding10 = const EdgeInsets.symmetric(vertical: 10.0);

  static const horizontalPadding5 = const EdgeInsets.symmetric(horizontal: 5.0);

  static const horizontalPadding10 =
      const EdgeInsets.symmetric(horizontal: 10.0);

  static const horizontalPadding20 =
      const EdgeInsets.symmetric(horizontal: 20.0);

  static const leftPadding20 = const EdgeInsets.only(left: 20.0);

  static const verticalHorizontalpadding1020 =
      const EdgeInsets.symmetric(vertical: 10, horizontal: 20);

  static const verticalHorizontalPadding25 =
      const EdgeInsets.symmetric(vertical: 2, horizontal: 5);

  static const verticalBox10 = const SizedBox(height: 10.0);

  static const verticalBox20 = const SizedBox(height: 20.0);

  static const verticalBox30 = const SizedBox(height: 30.0);

  static Widget loadingViewState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget emptyViewState(String text) {
    return Center(
      child: Text(text),
    );
  }

  static Widget errorViewState(String text) {
    return Center(
      child: Text(text),
    );
  }
}
