import 'package:barter_system/linker.dart';

class SettingButton extends StatelessWidget {
  String text;
  VoidCallback? ontap;
  SettingButton({required this.text,required this.ontap,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:5.0),
      child: InkWell(
        onTap: ontap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 7,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(text:text, size: 14, weight: FontWeight.w400),
              ],
            ),
            const Divider(color: Colors.grey,thickness: 1,),
          ],
        ),
      ),
    );
  }
}
