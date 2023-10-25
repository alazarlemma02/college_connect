// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connect/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/helper.dart';
import 'login.dart';
import 'verification.dart';

List genders = ["Male", "Female", "Other", "Don't specify"];
bool isLoading = false;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  String? _hover;
  String? _type;
  String? _genderValue;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController1 = TextEditingController();
  final nameController = TextEditingController();
  final nameController1 = TextEditingController();
  final pnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            //Form Field
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 30, top: 25),
                children: [
                  const SizedBox(
                    height: 15,
                  ),

                  const Center(
                    child: Text(
                      'Create\nAccount',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginScreen())),
                        child: const Text("Already have account? Login")),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (event) {
                          setState(() {
                            _hover = "firstYear";
                          });
                        },
                        onExit: (v) {
                          setState(() {
                            _hover = null;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _type = "firstYear";
                            });
                          },
                          child: SizedBox(
                            height: 90,
                            width: getWidth(context) > 1200 ? 342 : 300,
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: _hover == "firstYear"
                                  ? const Alignment(0, -1)
                                  : const Alignment(0, 1),
                              child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      border: Border.all(
                                          color: _type == "firstYear"
                                              ? Colors.green
                                              : Colors.transparent)),
                                  child: Center(
                                    child: ListTile(
                                      leading: const Icon(
                                        CupertinoIcons.person,
                                        size: 35,
                                      ),
                                      title: const Text(
                                        "First Year",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "semiBold"),
                                      ),
                                      subtitle: const Text(
                                          "Find colleges and apply online"),
                                      trailing: Icon(
                                        _type == "firstYear"
                                            ? Icons.check_circle_rounded
                                            : Icons.circle,
                                        size: 30,
                                        color: _type == "firstYear"
                                            ? Colors.green
                                            : Colors.pink.shade100,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (event) {
                          setState(() {
                            _hover = "transfer";
                          });
                        },
                        onExit: (v) {
                          setState(() {
                            _hover = null;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _type = "transfer";
                            });
                          },
                          child: SizedBox(
                            height: 90,
                            width: 300,
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: _hover == "transfer"
                                  ? const Alignment(0, -1)
                                  : const Alignment(0, 1),
                              child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      border: Border.all(
                                          color: _type == "transfer"
                                              ? Colors.green
                                              : Colors.transparent)),
                                  child: Center(
                                    child: ListTile(
                                      leading: const Icon(
                                        CupertinoIcons.person,
                                        size: 35,
                                      ),
                                      title: const Text(
                                        "Transfer",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "semiBold"),
                                      ),
                                      subtitle: const Text(
                                          "Transfer from any college."),
                                      trailing: Icon(
                                        _type == "transfer"
                                            ? Icons.check_circle_rounded
                                            : Icons.circle,
                                        size: 30,
                                        color: _type == "transfer"
                                            ? Colors.green
                                            : Colors.pink.shade100,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (event) {
                          setState(() {
                            _hover = "collegeAdmin";
                          });
                        },
                        onExit: (v) {
                          setState(() {
                            _hover = null;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _type = "collegeAdmin";
                            });
                          },
                          child: SizedBox(
                            height: 90,
                            width: 300,
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: _hover == "collegeAdmin"
                                  ? const Alignment(0, -1)
                                  : const Alignment(0, 1),
                              child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      border: Border.all(
                                          color: _type == "collegeAdmin"
                                              ? Colors.green
                                              : Colors.transparent)),
                                  child: Center(
                                    child: ListTile(
                                      leading: const Icon(
                                        CupertinoIcons.person,
                                        size: 35,
                                      ),
                                      title: const Text(
                                        "College Admin",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "semiBold"),
                                      ),
                                      subtitle:
                                          const Text("Signup your college."),
                                      trailing: Icon(
                                        _type == "collegeAdmin"
                                            ? Icons.check_circle_rounded
                                            : Icons.circle,
                                        size: 30,
                                        color: _type == "collegeAdmin"
                                            ? Colors.green
                                            : Colors.pink.shade100,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (getWidth(context) > 720)
                        const SizedBox(
                          height: 200,
                          width: 200,
                          child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/logo.jpg")),
                        ),
                      Center(
                        child: SizedBox(
                          width: 300,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                //Name
                                TextFormField(
                                  validator: (val) => val!.isEmpty
                                      ? 'First name required'
                                      : null,
                                  controller: nameController,
                                  keyboardType: TextInputType.name,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                      labelText: 'First name',
                                      labelStyle:
                                          TextStyle(fontFamily: 'light')),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  validator: (val) => val!.isEmpty
                                      ? 'Last name required'
                                      : null,
                                  controller: nameController1,
                                  keyboardType: TextInputType.name,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                      labelText: 'Last name',
                                      labelStyle:
                                          TextStyle(fontFamily: 'light')),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                //Email
                                TextFormField(
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter Your Email' : null,
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                      labelText: 'Email',
                                      labelStyle:
                                          TextStyle(fontFamily: 'RobotoLight')),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                //pn
                                TextFormField(
                                  validator: (val) => val!.length < 9
                                      ? 'PhoneNumber must be 9 characters'
                                      : null,
                                  controller: pnController,
                                  style: const TextStyle(),
                                  decoration: const InputDecoration(
                                      prefix: Text(
                                        '+251  ',
                                        style: TextStyle(),
                                      ),
                                      labelText: 'Phone number',
                                      labelStyle:
                                          TextStyle(fontFamily: 'RobotoLight')),
                                  keyboardType: TextInputType.phone,
                                  maxLength: 9,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                //Password
                                TextFormField(
                                  validator: (val) => val!.length < 8
                                      ? 'Password must be higher than 8 characters'
                                      : null,
                                  controller: passwordController,
                                  style: const TextStyle(),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      labelText: 'Password',
                                      labelStyle:
                                          TextStyle(fontFamily: 'RobotoLight')),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                //Password
                                TextFormField(
                                  validator: (val) => val!.length < 8
                                      ? 'Password must be higher than 8 characters'
                                      : null,
                                  controller: passwordController1,
                                  style: const TextStyle(),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      labelText: 'Confirm password',
                                      labelStyle:
                                          TextStyle(fontFamily: 'RobotoLight')),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                //Gender
                                if (_type != "College Admin")
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: DropdownMenu(
                                      label: const Text("Select Gender"),
                                      onSelected: (v) {
                                        setState(() {
                                          _genderValue = v;
                                        });
                                      },
                                      dropdownMenuEntries: genders
                                          .map((e) => DropdownMenuEntry(
                                              value: e, label: e))
                                          .toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // TextButton(
                  //     onPressed: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 const TermScreen())),
                  //     child: const Text('Term and conditions'))
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 5,
            ),
            //SignIn Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                FloatingActionButton.extended(
                  heroTag: "signup",
                  backgroundColor: Colors.blueAccent,
                  onPressed: () async {
                    if (isLoading == false) {
                      setState(() {
                        isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        if (passwordController1.text.trim() ==
                            passwordController.text.trim()) {
                          if (_type != "College Admin" &&
                              _genderValue == null) {
                            setState(() {
                              isLoading = false;
                            });
                            showSnackBar(context, "Select Gender");
                          } else {
                            try {
                              await users
                                  .where('fullName'.toLowerCase(),
                                      isEqualTo:
                                          "${nameController.text}${nameController1.text}"
                                              .toLowerCase())
                                  .limit(1)
                                  .get()
                                  .then((value) async {
                                if (value.docs.length == 1) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showSnackBar(
                                      context, "This name is already in use");
                                } else {
                                  await users
                                      .where('phoneNumber',
                                          isEqualTo: int.parse(
                                              pnController.text.trim()))
                                      .limit(1)
                                      .get()
                                      .then((value) async {
                                    if (value.docs.length == 1) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      showSnackBar(context,
                                          "This phone number is already in use");
                                    } else {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                        email: emailController.text
                                            .trim()
                                            .replaceAll(' ', ''),
                                        password: passwordController.text,
                                      )
                                          .then((value) async {
                                        await createUser();
                                      });
                                    }
                                  });
                                }
                              });
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                if (kDebugMode) {
                                  print('The password provided is too weak.');
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                showSnackBar(context, "Password is too weak");
                              } else if (e.code == 'email-already-in-use') {
                                setState(() {
                                  isLoading = false;
                                });
                                showSnackBar(
                                    context, "Email is already in use");
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        } else {
                          showSnackBar(context, "Password not matching");
                        }
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  label: isLoading == true
                      ? const SizedBox(
                          height: 17,
                          width: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            backgroundColor: Colors.white,
                          ))
                      : const Text(
                          'SignUp',
                          style: TextStyle(color: Colors.white),
                        ),
                )
              ],
            ),

            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future createUser() async {
    List array = [];
    String c =
        "${nameController.text.trim().toLowerCase()}${nameController1.text.trim().toLowerCase()}";
    for (int i = 1; i < c.length + 1; i++) {
      array.add(c.substring(0, i));
    }

    await users.doc(uid()).set({
      'firstName': nameController.text,
      'lastName': nameController1.text,
      'fullName': "${nameController.text}${nameController1.text}".toLowerCase(),
      'email': emailController.text.trim().replaceAll(' ', ''),
      'type': _type,
      "search": array,
      'phoneNumber': int.parse(pnController.text.trim()),
      'timeStamp': FieldValue.serverTimestamp(),
      if (_type != "College Admin") 'gender': _genderValue
    }).then((value) async {
      //Storing user data on cache to maintian state
      usersData = {
        "firstName": nameController.text,
        "lastName": nameController1.text,
        "type": _type
      };

      //Saving user data on local storage
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('userFirstName', nameController.text);
      sp.setString('userLastName', nameController1.text);
      sp.setString('userType', _type!);

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
      setState(() {
        isLoading = false;
      });
      return true;
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add user: $error");
      }
      setState(() {
        isLoading = false;
      });
      return true;
    });
  }
}
