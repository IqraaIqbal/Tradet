import 'package:barter_system/linker.dart';

class CustomText extends StatelessWidget {
  String text;
  double size;
  FontWeight weight;
  Color? color;
  CustomText(
      {super.key,
      required this.text,
      required this.size,
      required this.weight,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
