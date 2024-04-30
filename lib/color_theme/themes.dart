import 'package:flutter/material.dart';
import 'package:tumobile/color_theme/color_constants.dart';

class Themes {
  // final static ThemeData tum_theme;
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.accentColor,
    
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.accentColor,
  );
}
