import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../global/color_list.dart';

enum AppTheme {
  Light,
  Dark,
}

final appThemes = {
  AppTheme.Light: ThemeData().copyWith(
    primaryColor: ColorList.primaryCream,
    accentColor: ColorList.primaryRed,
    scaffoldBackgroundColor: ColorList.primaryCream,
    cupertinoOverrideTheme: CupertinoThemeData(
      //* for cursor color
      primaryColor: ColorList.primaryRed,
      //* for alertDialog color
      brightness: Brightness.light,
    ),
    cursorColor: ColorList.primaryRed,
    appBarTheme: AppBarTheme(
      //* for status bar
      brightness: Brightness.light,
      textTheme: TextTheme(
        title: TextStyle(
          color: ColorList.primaryRed,
        ),
      ),
      iconTheme: IconThemeData(
        color: ColorList.primaryRed,
      ),
      elevation: 0,
    ),
  ),
  AppTheme.Dark: ThemeData.dark().copyWith(
    primaryColor: ColorList.primaryBlack,
    accentColor: ColorList.primaryCream,
    scaffoldBackgroundColor: ColorList.primaryBlack,
    cupertinoOverrideTheme: CupertinoThemeData(
      //* for cursor color
      primaryColor: ColorList.primaryCream,
      //* for alertDialog color
      brightness: Brightness.dark,
    ),
    cursorColor: ColorList.primaryCream,
    appBarTheme: AppBarTheme(
      //* for status bar
      brightness: Brightness.dark,
      textTheme: TextTheme(
        title: TextStyle(
          color: ColorList.primaryCream,
        ),
      ),
      iconTheme: IconThemeData(
        color: ColorList.primaryCream,
      ),
      elevation: 0,
    ),
  ),
};
