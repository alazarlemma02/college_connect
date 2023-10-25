import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String title = "College Connect";

CollectionReference colleges = FirebaseFirestore.instance.collection('College');
CollectionReference users = FirebaseFirestore.instance.collection('Users');
String uid() => FirebaseAuth.instance.currentUser!.uid;

Map usersData = {};

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

String generateUid(int min, int max) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  int length = min + Random().nextInt(max - min);

  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
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
