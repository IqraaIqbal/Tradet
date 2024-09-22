import 'package:barter_system/linker.dart';

ThemeData lightTheme =ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: MyColors.backgroundLight,
    primary: MyColors.primary,
    secondary: MyColors.secondary,
    tertiary: Colors.black,
    outline: Colors.white,
  )
);