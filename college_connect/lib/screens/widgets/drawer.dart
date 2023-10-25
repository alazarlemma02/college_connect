import 'package:college_connect/screens/landing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../college.dart';

class MyWidgets {
  drawer(context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (FirebaseAuth.instance.currentUser != null)
              TextButton(
                  onPressed: () async => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CollegeScreen(),
                      )),
                  child: Text(
                    "Add college",
                    style: TextStyle(color: Colors.blueGrey.shade700),
                  )),
            const SizedBox(
              height: 20,
            ),
            if (FirebaseAuth.instance.currentUser != null)
              TextButton(
                  onPressed: () async => await logOut(context),
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.blueGrey.shade700),
                  )),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

logOut(context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear;
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      ),
      (route) => false);
}
