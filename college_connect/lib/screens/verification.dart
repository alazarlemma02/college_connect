import 'dart:async';
import 'package:college_connect/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/login.dart';
import '../helpers/helper.dart';

Timer? _timer;

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Icon(
                  Icons.mail_outlined,
                  size: 100,
                ),
              ),
              const Text(
                "Verify your email address",
                style: TextStyle(fontFamily: 'bold', fontSize: 18),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Text(
                    "We just sent email verification link on your email. Please check your email and click on the link to confirm your identity.",
                    style: TextStyle(color: Colors.grey.shade700),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Text(
                    "If the app doesn't auto redirect after verification, please click on the Continue button.",
                    style: TextStyle(color: Colors.grey.shade700),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(
                height: 40,
              ),
              OutlinedButton(
                onPressed: () async {
                  var user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await user.reload().then((value) {
                      if (user.emailVerified) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false);
                      } else {
                        showSnackBar(context, "Email not verified");
                      }
                    });
                  }
                },
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(color: Colors.black, width: 2)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child:
                      Text("Continue", style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {
                    var user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      user.sendEmailVerification().then((value) {
                        showSnackBar(context, "New verification link sent");
                      }).catchError((onError) {
                        showSnackBar(
                            context, "Failed to send new verification link");
                      });
                    }
                  },
                  child: const Text("Resend E-Mail Link")),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.rotate(
                          angle: 3.14,
                          child: const Icon(Icons.arrow_right_alt)),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("back to login"),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification().catchError((onError) {
        showSnackBar(context, "Failed to send new verification link");
      });
    }

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (user != null) {
        await user.reload().then((value) {
          if (user.emailVerified) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
            timer.cancel();
          }
        });
      }
    });
  }
}
