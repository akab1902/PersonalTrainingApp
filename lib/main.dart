import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_training_app/core/const/color_constants.dart';
import 'package:personal_training_app/screens/nav_bar/page/nav_bar_page.dart';
import 'package:personal_training_app/screens/signin/page/signin_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Training App',
      theme: ThemeData(
          fontFamily: 'Montserrat', primaryColor: ColorConstants.primaryColor),
      home: isLoggedIn ? const NavBarPage() : const SignInPage(),
    );
  }
}
