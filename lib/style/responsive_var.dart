import 'package:flutter/material.dart';

class Screen {
  // Static method to get height
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Static method to get width
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Static method to get text scale factor
  // static double textScaleFactor(BuildContext context) {
  //   return MediaQuery.of(context).textScaleFactor;
  // }

  // // Static method to get height as a percentage of the screen height
  // static double heightPercent(BuildContext context, double percent) {
  //   return height(context) * percent / 100;
  // }

  // // Static method to get width as a percentage of the screen width
  // static double widthPercent(BuildContext context, double percent) {
  //   return width(context) * percent / 100;
  // }

  // // Static method to get text scale factor based on a multiplier
  // static double textScale(BuildContext context, double multiplier) {
  //   return textScaleFactor(context) * multiplier;
  // }

  // // Static method to format a size as a string with percentage of screen dimensions
  // static String formatSize(BuildContext context, double value, {bool isWidth = true}) {
  //   return isWidth
  //       ? '${(value / width(context) * 100).toStringAsFixed(2)}% of screen width'
  //       : '${(value / height(context) * 100).toStringAsFixed(2)}% of screen height';
  // }
}
