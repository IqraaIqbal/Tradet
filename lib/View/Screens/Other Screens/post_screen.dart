import 'package:barter_system/linker.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/post_done.png",),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(text: "Your Post is Uploaded Successfuly", size: 14, weight: FontWeight.w500)
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                      onTap: (){
                        Get.to(NavBar(selectedIndex: 0,));
                      },
                      child: CustomButton(text: "Continue Scrolling")))
            ],
          ),
        ),
      ),
    );
  }
}
