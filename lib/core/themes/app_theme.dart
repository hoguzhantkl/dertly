import 'package:flutter/material.dart';

import 'custom_themes.dart';

extension AppTheme on ThemeData{
  ThemeData get appTheme => brightness == Brightness.light ? CustomThemes.lightTheme : CustomThemes.defaultTheme;
}