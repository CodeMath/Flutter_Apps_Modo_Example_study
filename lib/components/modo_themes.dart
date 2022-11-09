import 'package:flutter/material.dart';
import 'package:modo/components/modo_colors.dart';

class ModoTheme {
  static ThemeData get ligntTheme => ThemeData(
      primarySwatch: ModoColors.primaryMaterialColor,
      fontFamily: 'BMYEONSUNG',
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.white,
      textTheme: _textTheme,
      brightness: Brightness.light);

  static ThemeData get darkTheme => ThemeData(
      primarySwatch: ModoColors.primaryMaterialColor,
      fontFamily: 'BMYEONSUNG',
      splashColor: Colors.white,
      textTheme: _textTheme,
      brightness: Brightness.dark);

  static const TextTheme _textTheme = TextTheme(
      headline4: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
      subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      subtitle2: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyText1: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
      bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
      button: TextStyle(fontSize: 12, fontWeight: FontWeight.w300));
}
