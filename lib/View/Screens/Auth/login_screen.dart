import 'package:flutter/cupertino.dart';
import 'package:barter_system/linker.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPass = false;

  @override
  Widget build(BuildContext context) {
    Loading controller= Get.put(Loading());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: "Welcome\nBack!", size: 30, weight: FontWeight.bold),
              const SizedBox(
                height: 0,
              ),
              CustomText(
                text: "Hey! Good to see you again.",
                size: 15,
                weight: FontWeight.normal,
              ),
              const SizedBox(
                height: 50,
              ),
              CustomText(text: "Sign in", size: 30, weight: FontWeight.bold),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  )),
                  prefixIcon: const Icon(CupertinoIcons.mail,
                      color: MyColors.secondary),
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
                  suffixIcon: showPass
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              showPass = false;
                            });
                          },
                          child: const Icon(
                            CupertinoIcons.eye,
                            color: MyColors.secondary,
                          ))
                      : InkWell(
                          onTap: () {
                            setState(() {
                              showPass = true;
                            });
                          },
                          child: const Icon(
                            CupertinoIcons.eye_slash,
                            color: MyColors.secondary,
                          )),
                  prefixIcon: const Icon(
                    CupertinoIcons.padlock,
                    color: MyColors.secondary,
                  ),
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GetBuilder<Loading>(
                builder: (contr) {
                  return InkWell(
                    onTap: () {
                      AuthService().signIn(
                          emailController.text, passwordController.text);
                      emailController.clear();
                      passwordController.clear();
                    },
                    child: ((contr).loading)?LoadingButton():CustomButton(
                      text: 'Sign In',
                    ),
                  );
                }
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                      text: 'Don\'t Have an Account?',
                      size: 12,
                      weight: FontWeight.normal),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                        print(controller.loading);
                      },
                      child: CustomText(
                        text: ' SignUp',
                        size: 12,
                        weight: FontWeight.w600,
                        color: MyColors.secondary,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
