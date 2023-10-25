// ignore_for_file: use_build_context_synchronously

import 'package:college_connect/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/signup.dart';
import '../Screens/verification.dart';
import '../helpers/helper.dart';

final _formKey = GlobalKey<FormState>();
bool isLoading = false;
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
UserCredential? userCredential;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isLandscape = getOrientation(context);
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(
            child: Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/logo.jpg")),
              ),
            ),
          ),
          Container(
            width: isLandscape ? width * .3 : width,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(-1, -1)),
            ], color: Colors.white),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 200, 20, 20),
              children: [
                Container(
                  alignment: width < 600
                      ? const Alignment(-1, 1)
                      : const Alignment(-1, 1),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'bold',
                        fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: width > 600 ? width * .3 : width,
                        child: TextFormField(
                          validator: (val) => val!.length < 8
                              ? 'Email must be higher than 8 characters'
                              : null,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.black,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          enableSuggestions: true,
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.black,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.black,
                              )),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  color: Colors.black, fontFamily: 'sans')),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: width > 600 ? width * .3 : width,
                        child: TextFormField(
                          validator: (val) => val!.length < 8
                              ? 'Password must be higher than 8 characters'
                              : null,
                          controller: passwordController,
                          obscureText: true,
                          cursorColor: Colors.black,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.black,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.black,
                              )),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Colors.black, fontFamily: 'sans')),
                          onFieldSubmitted: (_) async {
                            if (isLoading == false) {
                              setState(() {
                                isLoading = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                try {
                                  userCredential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: emailController.text
                                              .trim()
                                              .replaceAll(' ', ''),
                                          password: passwordController.text);
                                  FirebaseAuth.instance
                                      .authStateChanges()
                                      .listen((user) async {
                                    if (user != null) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      await saveUserData();
                                      if (!kIsWeb && !user.emailVerified) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const VerificationScreen(),
                                            ));
                                      } else {
                                        showSnackBar(
                                            context, "Login successful");
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen(),
                                            ),
                                            (route) => false);
                                      }
                                    }
                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    if (kDebugMode) {
                                      print('No user found for that email.');
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showSnackBar(
                                        context, "Invalid email address");
                                  } else if (e.code == 'wrong-password') {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showSnackBar(context, "Wrong password");
                                    if (kDebugMode) {
                                      print(
                                          'Wrong password provided for that user.');
                                    }
                                  }
                                }
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage())),
                        child: const Text(
                          "Don't have an account? create one",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      FloatingActionButton.extended(
                        heroTag: 'signin',
                        backgroundColor: Colors.blueAccent,
                        onPressed: () async {
                          if (isLoading == false) {
                            setState(() {
                              isLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              try {
                                userCredential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: emailController.text
                                            .trim()
                                            .replaceAll(' ', ''),
                                        password: passwordController.text);
                                FirebaseAuth.instance
                                    .authStateChanges()
                                    .listen((user) async {
                                  if (user != null) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    await saveUserData();
                                    if (!kIsWeb && !user.emailVerified) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const VerificationScreen(),
                                          ));
                                    } else {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ),
                                          (route) => false);
                                    }
                                  }
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found' ||
                                    e.code == 'wrong-password') {
                                  // if (kDebugMode) {
                                  //   print('No user found with this email.');
                                  // }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showSnackBar(context,
                                      "Invalid email address or password");
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showSnackBar(context, "Login failed");
                                  // if (kDebugMode) {
                                  //   print('Wrong password provided for this user.');
                                  // }
                                }
                              }
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        label: isLoading == true
                            ? const SizedBox(
                                height: 17,
                                width: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  backgroundColor: Colors.black,
                                ))
                            : const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

saveUserData() async {
  var snap = await users.doc(uid()).get();
  Map user = snap.data() as Map;
  //Storing user data on cache to maintain state
  usersData = {
    "firstName": user["firstName"],
    "lastName": user["lastName"],
    "type": user["type"]
  };
  //Saving user data on local storage
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString('userFirstName', user["firstName"]);
  sp.setString('userLastName', user["lastName"]);
  sp.setString('userType', user["type"]);
}
