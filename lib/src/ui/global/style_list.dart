import 'package:flutter/material.dart';
import '../../app_localizations.dart';

class StyleList {
  static const TextStyle appBarTitleStyle = const TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle buttonTextStyle = const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle baseTitleTextStyle = const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  static const EdgeInsets removePadding = const EdgeInsets.all(0.0);

  static const EdgeInsets allPadding10 = const EdgeInsets.all(10.0);

  static const EdgeInsets horizontalPadding20 = const EdgeInsets.symmetric(
    horizontal: 20.0,
  );

  static const EdgeInsets verticalHorizontalPaddding1020 =
      const EdgeInsets.symmetric(vertical: 10, horizontal: 20);

  static const EdgeInsets verticalHorizontalPaddding25 =
      const EdgeInsets.symmetric(vertical: 2, horizontal: 5);

  static const SizedBox verticalBox10 = const SizedBox(
    height: 10.0,
  );

  static const SizedBox verticalBox20 = const SizedBox(
    height: 20.0,
  );

  static String localizedAlertTtile(BuildContext context, String content) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'en':
        return '${AppLocalizations.of(context).translate('alertDeleteTitle')} "$content"${AppLocalizations.of(context).translate('questionMark')}';
      case 'ja':
        return '"$content"${AppLocalizations.of(context).translate('alertDeleteTitle')}${AppLocalizations.of(context).translate('questionMark')}';
      default:
        return '${AppLocalizations.of(context).translate('alertDeleteTitle')} "$content"${AppLocalizations.of(context).translate('questionMark')}';
    }
  }

  static SnackBar baseSnackBar(
    BuildContext context,
    String snackBarText,
  ) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1000),
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        snackBarText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
        ),
      ),
    );
  }
}
