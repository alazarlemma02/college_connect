import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connect/screens/college.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/root.dart';

String title = "Menar";
Map product = {};
List cartItems = [];

GeoPoint? deliveryLocation;

CollectionReference colleges = FirebaseFirestore.instance.collection('College');
CollectionReference users = FirebaseFirestore.instance.collection('Users');
String uid() => FirebaseAuth.instance.currentUser!.uid;

addAll(List x) {
  double i = 0;
  for (var e in x) {
    if (e is int || e is double) {
      i += e;
    }
  }
  return i;
}

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

List<String> genders = ['Male', 'Female', "Other"];

void showSnackBar(BuildContext context, String sbTitle) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(sbTitle),
      action:
          SnackBarAction(label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

getWidth(context) {
  return MediaQuery.of(context).size.width;
}

getHeight(context) {
  return MediaQuery.of(context).size.height;
}

getOrientation(context) {
  //is landscape
  return MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
      ? true
      : false;
}

const MaterialColor primaryWhite = MaterialColor(
  _whitePrimaryValue,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFF9F8F8),
    500: Color(0xFFF9F1FF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);
const int _whitePrimaryValue = 0xFFF9F8F8;

const months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

logOut(context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear;
  await FirebaseAuth.instance.signOut();
  pageIndex = 0;
  pageController.animateToPage(0,
      duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const RootScreen(),
      ),
      (route) => false);
}

alertDialog(body, context, [title]) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Center(child: Text(title ?? "Oops")),
            content: Text(body),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Ok"))
            ],
          ));
}

currencyFormat(String input) {
  List array = input.split(".");
  String numString = array[0];

  if (numString.length < 4) {
    return numString;
  }
  String newString = "";
  for (int i = 0; i < numString.length; i++) {
    if ((numString.length - i - 1) % 3 == 0) {
      newString += "${numString[i]}${numString.length == i + 1 ? "." : ","}";
    } else {
      newString += numString[i];
    }
  }
  newString += array[1];
  return newString;
}

totalCalculator({required int price, int? quantity, int? variantPrice}) {
  return ((quantity ?? 1) * price) + (variantPrice ?? 0);
}

String generateUid(int min, int max) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  int length = min + Random().nextInt(max - min);

  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
}

drawer(context) {
  return Container(
    width: 250,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          if (FirebaseAuth.instance.currentUser != null)
            TextButton(
                onPressed: () async => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CollegeScreen(),
                    )),
                child: Text(
                  "Admin Portal",
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
