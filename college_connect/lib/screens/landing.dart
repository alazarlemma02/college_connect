import 'package:college_connect/Screens/login.dart';
import 'package:college_connect/Screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helpers/helper.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    double width = getWidth(context);
    double height = getHeight(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SizedBox(
            width: 45,
            height: 45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset("assets/images/logo.jpg", fit: BoxFit.contain),
            ),
          ),
        ),
        actions: [
          if (FirebaseAuth.instance.currentUser != null)
            Text(FirebaseAuth.instance.currentUser!.email.toString())
          else
            Row(
              children: [
                SizedBox(
                  height: 40,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    label: const Text("Login"),
                  ),
                ),
                const SizedBox(width: 15),
                if (width > 320)
                  SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ));
                      },
                      label: const Text("Create account"),
                    ),
                  ),
              ],
            ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        height: height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg.jpg",
                ),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 150,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  "College Connect",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35, fontFamily: 'bold', color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width > 720 ? 100 : 10),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.25),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      "Discover comprehensive information on various colleges, their programs, admission requirements, and acceptance rates.  Our user-friendly interface provides easy navigation, allowing you to access valuable resources, application tips, and deadlines. Stay up-to-date with the latest trends in the college admissions landscape through our blog and news section. We're here to empower and support you every step of the way as you embark on this exciting chapter of your educational future. Start your college journey with confidence on College Connect!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'regular',
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ]),
        ),
      ),
    );
  }
}
