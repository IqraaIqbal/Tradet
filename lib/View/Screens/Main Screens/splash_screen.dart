// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_build_context_synchronously
import 'package:barter_system/linker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

 class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    await Future.delayed(
        Duration(seconds: 3)); // Simulating a splash screen delay

    if (user != null) {
      // User is signed in, navigate to the home screen
      Get.offAll(NavBar(), predicate: (_) => false);
    } else {
      // User is not signed in, navigate to the login screen
      Get.offAll(LogInScreen(), predicate: (_) => false);
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        body: Center(
          child: SizedBox(
              height: 300,
              width: 300,
              child: Image.asset('assets/images/splash.png')),
        ),
      );
    }
  }

