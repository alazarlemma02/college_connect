import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/verification.dart';
import '../helpers/helper.dart';

List genders = ["Male", "Female","Other","Don't specify"];
bool isLoading = false;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
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
      body: CustomPaint(
        painter: BackgroundSignUp(),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: <Widget>[
                  //Header
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: const Text(
                        'Create\nAccount',
                        style: TextStyle( fontSize: 40),
                      ),
                    ),
                  ),

                  //Form Field
                  Expanded(
                    flex: 6,
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 30),
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //Name
                              TextFormField(
                                validator: (val) =>
                                    val!.isEmpty ? 'First name required' : null,
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(),
                                decoration: const InputDecoration(
                                    errorStyle: TextStyle(),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide()),
                                    labelText: 'First name',
                                    labelStyle: TextStyle(

                                        fontFamily: 'light')),
                              ),
                              TextFormField(
                                validator: (val) =>
                                    val!.isEmpty ? 'Last name required' : null,
                                controller: nameController1,
                                keyboardType: TextInputType.name,

                                style: const TextStyle(),
                                decoration: const InputDecoration(
                                    errorStyle: TextStyle(),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide()),
                                    labelText: 'Last name',
                                    labelStyle: TextStyle(

                                        fontFamily: 'light')),
                              ),

                              //Email
                              TextFormField(
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter Your Email' : null,
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,

                                style: const TextStyle(),
                                decoration: const InputDecoration(
                                    errorStyle: TextStyle(),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide()),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(

                                        fontFamily: 'RobotoLight')),
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
                                    errorStyle: TextStyle(),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide()),
                                    labelText: 'Phone number',
                                    labelStyle: TextStyle(

                                        fontFamily: 'RobotoLight')),
                                keyboardType: TextInputType.phone,
                                maxLength: 9,
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
                                    errorStyle: TextStyle(),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide()),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(

                                        fontFamily: 'RobotoLight')),
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
                                    errorStyle: TextStyle(),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide()),
                                    labelText: 'Confirm password',
                                    labelStyle: TextStyle(

                                        fontFamily: 'RobotoLight')),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              //Gender
                              Align(
                                alignment: Alignment.centerLeft,
                                child: DropdownMenu(
                                  label: const Text("Select Gender"),
                                    onSelected: (v){
                                    setState(() {
                                      _genderValue = v;
                                    });
                                    },
                                    dropdownMenuEntries: genders.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
                                ),
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        // TextButton(
                        //     onPressed: () => Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (BuildContext context) =>
                        //                 const TermScreen())),
                        //     child: const Text('Term and conditions'))
                        const SizedBox(height: 20,)
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  //SignIn Buttons
                  Expanded(
                    flex: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Sign up',
                          style: TextStyle(

                              fontSize: 25,
                              fontWeight: FontWeight.w500),
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
                                  if (_genderValue == null) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showSnackBar(context,"Select Gender");
                                  } else {
                                    try {

                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .where('fullName'.toLowerCase(),
                                              isEqualTo: "${nameController.text}${nameController1.text}".toLowerCase())
                                          .limit(1)
                                          .get()
                                          .then((value) async {
                                        if (value.docs.length == 1) {
                                          // if (kDebugMode) {
                                          //   print('This name is already in use');
                                          // }
                                          setState(() {
                                            isLoading = false;
                                          });
                                          showSnackBar(context, "This name is already in use");
                                        } else {
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .where('phoneNumber',
                                                  isEqualTo: int.parse(pnController.text.trim()))
                                              .limit(1)
                                              .get()
                                              .then((value) async {
                                            if (value.docs.length == 1) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              showSnackBar(context, "This phone number is already in use");
                                            } else {
                                               await FirebaseAuth
                                                  .instance
                                                  .createUserWithEmailAndPassword(
                                                    email: emailController.text
                                                        .trim()
                                                        .replaceAll(' ', ''),
                                                    password: passwordController.text,
                                                  )
                                                  .then((value)
                                                async {
                                                await createUser();
                                              });
                                            }
                                          });
                                        }
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        if (kDebugMode) {
                                          print(
                                              'The password provided is too weak.');
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showSnackBar(context, "Password is too weak");
                                      } else if (e.code ==
                                          'email-already-in-use') {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showSnackBar(context, "Email is already in use");
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
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future createUser() async {
    await users.doc(uid()).set({
      'firstName': nameController.text,
      'lastName': nameController1.text,
      'fullName': "${nameController.text}${nameController1.text}".toLowerCase(),
      'email': emailController.text.trim().replaceAll(' ', ''),
      'password': passwordController.text,
      'phoneNumber': int.parse(pnController.text.trim()),
      'date': FieldValue.serverTimestamp(),
      'gender': _genderValue
    }).then((value) async {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const VerificationScreen(),));
      // showSnackBar(context, "Account created successfully");
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

class BackgroundSignUp extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.white;
    canvas.drawPath(mainBackground, paint);

    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.5);
    blueWave.quadraticBezierTo(sw * 0.5, sh * 0.45, sw * 0.2, 0);
    blueWave.close();
    paint.color = Colors.blue;
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(
        sw * 0.95, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.4);
    greyWave.close();
    paint.color = Colors.white;
    canvas.drawPath(greyWave, paint);

    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.7, 0);
    yellowWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Colors.deepOrange.shade400;
    canvas.drawPath(yellowWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
