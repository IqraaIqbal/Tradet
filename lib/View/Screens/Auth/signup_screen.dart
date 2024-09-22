import 'package:barter_system/linker.dart';
import 'package:flutter/cupertino.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confPasswordController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  bool showPass = false;
  bool showConfPass = false;

  @override
  Widget build(BuildContext context) {
    Loading controller= Get.put(Loading());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              right: 10.0, left: 10.0, top: 150, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Sign Up", size: 30, weight: FontWeight.bold),
              const SizedBox(
                height: 0,
              ),
              CustomText(
                text: "We are happy to have you here.",
                size: 15,
                weight: FontWeight.normal,
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  )),
                  prefixIcon: const Icon(
                    CupertinoIcons.person,
                    color: MyColors.secondary,
                  ),
                  hintText: 'Full Name',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  )),
                  prefixIcon: const Icon(
                    CupertinoIcons.device_phone_portrait,
                    color: MyColors.secondary,
                  ),
                  hintText: 'Phone Number',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  )),
                  prefixIcon: const Icon(
                    CupertinoIcons.mail,
                    color: MyColors.secondary,
                  ),
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: passwordController,
                obscureText: showPass ? false : true,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  )),
                  prefixIcon: const Icon(
                    CupertinoIcons.padlock,
                    color: MyColors.secondary,
                  ),
                  suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                      child: Icon(
                        showPass
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                        color: MyColors.secondary,
                      )),
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: confPasswordController,
                obscureText: showConfPass ? false : true,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  )),
                  prefixIcon: const Icon(
                    CupertinoIcons.padlock,
                    color: MyColors.secondary,
                  ),
                  suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          showConfPass = !showConfPass;
                        });
                      },
                      child: Icon(
                        showConfPass
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                        color: MyColors.secondary,
                      )),
                  hintText: 'Confirm Password',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GetBuilder<Loading>(
                builder: (controller) {
                  return InkWell(
                      onTap: () {
                        AuthService().signUp(
                            nameController.text,
                            emailController.text,
                            phoneNumberController.text,
                            passwordController.text,
                            confPasswordController.text,
                        );
                      },
                      child: (controller?.loading ?? false) ?LoadingButton():CustomButton(text: "Sign  Up"));
                }
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                      text: 'Already Have an Account?',
                      size: 12,
                      weight: FontWeight.normal),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LogInScreen()));
                    },
                    child: CustomText(
                      text: ' SignIn',
                      size: 12,
                      weight: FontWeight.w600,
                      color: const Color(0xffEA613A),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
