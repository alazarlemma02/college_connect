// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:college_connect/helpers/helper.dart';
import 'package:college_connect/helpers/college_application_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'cart.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({super.key});
  @override
  ApplicationFormState createState() => ApplicationFormState();
}

class ApplicationFormState extends State<ApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  DateTime? dateOfBirthController;
  File? uploadedFile;
  List<Uint8List> imageList = [];
  List<String> collegeEmails = [];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('College application form'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          if (cartItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset("assets/images/oops.jpg")),
                  const Text(
                    "Oops",
                    style: TextStyle(fontSize: 30, fontFamily: "bold"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 20, fontFamily: "semiBold"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      "Looks like you haven't added anything to your cart yet.",
                      style: TextStyle(color: Colors.grey.shade700),
                      textAlign: TextAlign.center),
                ],
              ),
            )
          else
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime(2002, 1, 30),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        setState(() {
                          if (value != null) {
                            dateOfBirthController = value;
                          }
                        });
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(dateOfBirthController == null
                              ? "Date of birth"
                              : "${dateOfBirthController!.day} - ${dateOfBirthController!.month} -${dateOfBirthController!.year}"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      for (var item in imageList)
                        GestureDetector(
                          onLongPress: () {
                            imageList.remove(item);
                            setState(() {});
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.indigo,
                                image: DecorationImage(
                                    image: MemoryImage(item),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> pickedImages =
                          await picker.pickMultiImage();
                      for (var image in pickedImages) {
                        if (imageList.length < 6) {
                          await image.readAsBytes().then((value) {
                            imageList.add(value);
                          });
                        }
                      }
                      if (imageList.isNotEmpty) {
                        setState(() {});
                      }
                    },
                    child: const Text(
                      'Select File to Upload',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'Submit Application',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getCartItems();
    super.initState();
  }

  Future getCartItems() async {
    if (FirebaseAuth.instance.currentUser != null && cartItems.isEmpty) {
      var v = await users.doc(uid()).collection("cart").get();
      for (var v in v.docs) {
        Map<String, dynamic> i = {};
        i.addAll(v.data());
        i.addAll({"cid": v.id});
        cartItems.add(i);
      }
      if (cartItems.isNotEmpty) {
        setState(() {});
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      for (Map item in cartItems) {
        await colleges.doc(item["id"]).get().then((value) {
          Map i = value.data() as Map;
          collegeEmails.add(i["email"]);
        });
      }
      final bool success = await sendApplication();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully!'),
          ),
        );
      } else {
        showSnackBar(context,
            'Failed to send application. Please check your credentials.');
      }
    }
  }

  Future<bool> sendApplication() async {
    final String formData = 'First Name: ${firstNameController.text}\n'
        'Last Name: ${lastNameController.text}\n'
        'Email: ${emailController.text}';

    try {
      await CollegeApplicationService.sendApplication(collegeEmails, formData);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error sending application: $e');
      }
      return false;
    }
  }
}
