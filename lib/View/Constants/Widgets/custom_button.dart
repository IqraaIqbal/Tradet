import 'package:barter_system/linker.dart';

class CustomButton extends StatelessWidget {
  String text;
  double? width;
  double? height;
  CustomButton({super.key,required this.text,this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height?? 50,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          //color: MyColors.primary,
          gradient: const LinearGradient(colors: [MyColors.secondary,MyColors.primary])
      ),
      child: Center(
        child: CustomText(
          text: text, size: 18, weight: FontWeight.w600,color: Colors.white,),
      ),
    );
  }
}
