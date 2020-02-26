import 'package:flutter/material.dart';
import '../../core/providers/base_provider.dart';
import '../../app_localizations.dart';

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

  static const horizontalPadding5 = const EdgeInsets.symmetric(horizontal: 5.0);

  static const horizontalPadding10 = const EdgeInsets.symmetric(
    horizontal: 10.0,
  );

  static const horizontalPadding20 = const EdgeInsets.symmetric(
    horizontal: 20.0,
  );

  static const verticalHorizontalpadding1020 =
      const EdgeInsets.symmetric(vertical: 10, horizontal: 20);

  static const verticalHorizontalPadding25 =
      const EdgeInsets.symmetric(vertical: 2, horizontal: 5);

  static const verticalBox10 = const SizedBox(
    height: 10.0,
  );

  static const verticalBox20 = const SizedBox(
    height: 20.0,
  );

  static const verticalBox30 = const SizedBox(
    height: 30.0,
  );

  static String localizedPrice(BuildContext context, int price) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'en':
        return '\$${price / 100}';
      case 'ja':
        return '\¥$price';
      default:
        return '\$${price / 100}';
    }
  }

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
