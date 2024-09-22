import 'package:barter_system/linker.dart';

class LoadingButton extends StatelessWidget {
  double? width;
  double? height;
  LoadingButton({super.key,this.width,this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??50,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          //color: MyColors.primary,
          gradient: const LinearGradient(colors: [MyColors.secondary,MyColors.primary])
      ),
      child: const Center(
        child:  SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(color: MyColors.secondary),
        ),
      ),
    );
  }
}
