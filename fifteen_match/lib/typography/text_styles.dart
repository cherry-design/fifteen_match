import 'package:flutter/material.dart';

class TextStyles {
  /// Title
  static TextStyle get title {
    return _baseStyle.copyWith(
      fontSize: 60,
      fontWeight: FontWeight.w700,
    );
  }

  /// Subtitle
  static TextStyle get subtitle {
    return _baseStyle.copyWith(
      fontSize: 18,
    );
  }

  /// Body
  static TextStyle get body {
    return _baseStyle.copyWith(
      fontSize: 18,
    );
  }

  /// Label
  static TextStyle get label {
    return _baseStyle.copyWith(
      fontSize: 26,
    );
  }

  /// Small
  static TextStyle get small {
    return _baseStyle.copyWith(
      fontSize: 16,
    );
  }

  /// Number
  static TextStyle get number {
    return _baseStyle.copyWith(
      fontSize: 25,
      fontWeight: FontWeight.w700,
    );
  }

  static const _baseStyle = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.black,
    fontWeight: FontWeight.w400,
  );
}
