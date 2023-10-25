import 'package:college_connect/helpers/helper.dart';
import 'package:college_connect/screens/home.dart';
import 'package:college_connect/screens/landing.dart';
import 'package:college_connect/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/verification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await loadCache();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDn0utYMfbCjXpBPEqzL04sHJeMxlv7DVI",
          authDomain: "college-connect-1.firebaseapp.com",
          projectId: "college-connect-1",
          storageBucket: "college-connect-1.appspot.com",
          messagingSenderId: "401186886646",
          appId: "1:401186886646:web:5e02f669bddeb070d0edd7",
          measurementId: "G-RVRGX9B9L7"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
          fontFamily: 'regular',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.green.shade50,
          ),
          inputDecorationTheme:
              const InputDecorationTheme(border: OutlineInputBorder())),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(strokeWidth: 1.5),
        ),
      ),
    );
  }

  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  checkAuth() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LandingScreen()));
      } else {
        if (!kIsWeb && !FirebaseAuth.instance.currentUser!.emailVerified) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VerificationScreen(),
              ));
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        }
      }
    });
  }
}

Future<Map> loadCache() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  if (sp.get("userType") == null) {
    saveUserData();
  } else {
    usersData = {
      "firstName": sp.get("userFirstName"),
      "lastName": sp.get("userLastName"),
      "type": sp.get("userType")
    };
  }
  return usersData;
}
