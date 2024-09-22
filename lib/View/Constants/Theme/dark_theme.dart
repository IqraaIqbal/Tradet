import 'package:barter_system/linker.dart';

ThemeData darkTheme =ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      background: MyColors.backgroundDark,
      primary: MyColors.primary,
      secondary: MyColors.secondary,
      tertiary: Colors.white,
      outline: Colors.black,
    )
);