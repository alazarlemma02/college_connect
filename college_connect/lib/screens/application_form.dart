// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connect/helpers/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'cart.dart';

bool _isLoading = false;

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({super.key});
  @override
  ApplicationFormState createState() => ApplicationFormState();
}

class ApplicationFormState extends State<ApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController highSchoolNameController = TextEditingController();
  TextEditingController testController = TextEditingController();
  TextEditingController gpaController = TextEditingController();
  TextEditingController essayController = TextEditingController();
  TextEditingController recommendersContactController = TextEditingController();
  TextEditingController letterOfRecommendationController =
      TextEditingController();
  TextEditingController financialInfoController = TextEditingController();
  TextEditingController rankController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  TextEditingController extracurricularActivitiesController =
      TextEditingController();
  DateTime? dateOfBirthController;
  DateTime? dateOfGraduationController;
  File? uploadedFile;
  List<Uint8List> academicImageList = [];
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
      body: Center(
        child: FutureBuilder(
            future: getCartItems(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  width: getWidth(context) < 720 ? 300 : 500,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Personal Information",
                            style:
                                TextStyle(fontSize: 20, fontFamily: "semiBold"),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(labelText: 'Full Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: emailController,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
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
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              height: 50,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(dateOfBirthController == null
                                      ? "Date of birth"
                                      : "${dateOfBirthController!.day} - ${dateOfBirthController!.month} -${dateOfBirthController!.year}"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Academic",
                            style:
                                TextStyle(fontSize: 20, fontFamily: "semiBold"),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: highSchoolNameController,
                            decoration: const InputDecoration(
                                labelText: 'Name of high school you attended'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the name of high school you attended';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: gpaController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9.]"))
                            ],
                            decoration: const InputDecoration(
                                labelText: 'Grade point average (GPA)'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your grade point average (GPA)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: rankController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                            ],
                            decoration: const InputDecoration(
                                labelText: 'Class rank (if applicable)'),
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
                                    dateOfGraduationController = value;
                                  }
                                });
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  )),
                              height: 50,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(dateOfGraduationController == null
                                      ? "Date of graduation or expected date"
                                      : "${dateOfGraduationController!.day} - ${dateOfGraduationController!.month} -${dateOfGraduationController!.year}"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: testController,
                            decoration: const InputDecoration(
                                labelText:
                                    'Standardized test scores (SAT, ACT, etc.)'),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: scoreController,
                            decoration: const InputDecoration(
                                labelText:
                                    'Coursework and grades in specific subjects'),
                            maxLines: 4,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: extracurricularActivitiesController,
                            decoration: const InputDecoration(
                                labelText: 'Extracurricular Activities'),
                            maxLines: 4,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: essayController,
                            decoration: const InputDecoration(
                                labelText: 'Personal statement or essay'),
                            maxLines: 7,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: recommendersContactController,
                            decoration: const InputDecoration(
                                labelText:
                                    'Contact information of the recommenders'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the name of high school you attended';
                              }
                              return null;
                            },
                            maxLines: 1,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: recommendersContactController,
                            decoration: const InputDecoration(
                                labelText: 'Recommendation letter'),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: financialInfoController,
                            decoration: const InputDecoration(
                                labelText: 'Financial Information'),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 15),
                          const Center(
                            child: Text(
                              "Transcripts or academic records",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: "semiBold"),
                            ),
                          ),
                          //Academic images
                          const SizedBox(height: 15),
                          Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                for (var item in academicImageList)
                                  GestureDetector(
                                    onLongPress: () {
                                      academicImageList.remove(item);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.indigo,
                                          image: DecorationImage(
                                              image: MemoryImage(item),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final List<XFile> pickedImages =
                                        await picker.pickMultiImage();
                                    for (var image in pickedImages) {
                                      if (academicImageList.length < 6) {
                                        await image.readAsBytes().then((value) {
                                          academicImageList.add(value);
                                        });
                                      }
                                    }
                                    if (academicImageList.isNotEmpty) {
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //
                          // //images
                          // const SizedBox(height: 15),
                          // Wrap(
                          //   crossAxisAlignment: WrapCrossAlignment.center,
                          //   alignment: WrapAlignment.center,
                          //   spacing: 20,
                          //   runSpacing: 20,
                          //   children: [
                          //     for (var item in imageList)
                          //       GestureDetector(
                          //         onLongPress: () {
                          //           imageList.remove(item);
                          //           setState(() {});
                          //         },
                          //         child: Container(
                          //           width: 120,
                          //           height: 120,
                          //           decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(15),
                          //               color: Colors.indigo,
                          //               image: DecorationImage(
                          //                   image: MemoryImage(item),
                          //                   fit: BoxFit.cover)),
                          //         ),
                          //       ),
                          //   ],
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.blue,
                          //   ),
                          //   onPressed: () async {
                          //     final ImagePicker picker = ImagePicker();
                          //     final List<XFile> pickedImages =
                          //         await picker.pickMultiImage();
                          //     for (var image in pickedImages) {
                          //       if (imageList.length < 6) {
                          //         await image.readAsBytes().then((value) {
                          //           imageList.add(value);
                          //         });
                          //       }
                          //     }
                          //     if (imageList.isNotEmpty) {
                          //       setState(() {});
                          //     }
                          //   },
                          //   child: const Text(
                          //     'Select File to Upload',
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          // ),
                          const SizedBox(height: 15),
                          Center(
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.green.shade300,
                              onPressed: !_isLoading
                                  ? () async {
                                      for (Map college in cartItems) {
                                        await uploadApplication(college["id"]);
                                      }
                                      // fot
                                    }
                                  : null,
                              icon: const Icon(
                                CupertinoIcons.cloud_upload,
                              ),
                              label: !_isLoading
                                  ? const Text(
                                      "Submit Application",
                                      style: TextStyle(fontFamily: 'bold'),
                                    )
                                  : const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          strokeWidth: 1.5,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                );
              } else {
                return Padding(
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
                );
              }
            }),
      ),
    );
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
    return cartItems;
  }

  Future uploadApplication(docId) async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      if (dateOfBirthController == null) {
        showSnackBar(context, "Please specify date of birth");
        setState(() {
          _isLoading = false;
        });
      } else if (academicImageList.isEmpty) {
        showSnackBar(context, "Please add at least 1 image");
        setState(() {
          _isLoading = false;
        });
      } else if (dateOfGraduationController == null) {
        showSnackBar(context, "Please specify date of graduation");
        setState(() {
          _isLoading = false;
        });
      } else {
        var array = [];
        String c = nameController.text.trim().toLowerCase();
        for (int i = 1; i < c.length + 1; i++) {
          array.add(c.substring(0, i));
        }
        applications.add({
          'name': nameController.text.trim(),
          'email': emailController.text.trim().toLowerCase(),
          'timeStamp': FieldValue.serverTimestamp(),
          "uid": uid(),
          if (rankController.text.isNotEmpty)
            'rank': int.parse(rankController.text),
          if (testController.text.isNotEmpty)
            'standardizedTest': testController.text.trim(),
          if (scoreController.text.isNotEmpty)
            'score': scoreController.text.trim(),
          if (extracurricularActivitiesController.text.isNotEmpty)
            'extracurricular': extracurricularActivitiesController.text.trim(),
          if (essayController.text.isNotEmpty)
            'essay': essayController.text.trim(),
          if (highSchoolNameController.text.isNotEmpty)
            'schoolName': highSchoolNameController.text.trim(),
          if (financialInfoController.text.isNotEmpty)
            'financialInformation': financialInfoController.text.trim(),
          if (letterOfRecommendationController.text.isNotEmpty)
            'essay': letterOfRecommendationController.text.trim(),
          if (recommendersContactController.text.isNotEmpty)
            'recommenderContact': recommendersContactController.text.trim(),
          if (dateOfGraduationController != null)
            'graduationDate':
                dateOfGraduationController!.millisecondsSinceEpoch,
          if (dateOfBirthController != null)
            'birthDate': dateOfBirthController!.millisecondsSinceEpoch,
          'collegeId': docId,
        }).then((value) async {
          await uploadImages(value.id);
          setState(() {
            _isLoading = false;
          });
          await users.doc(uid()).collection("cart").get().then((value) async {
            for (var element in value.docs) {
              await element.reference.delete();
            }
          }).then((value) {
            Navigator.pop(context);
          });
        }).catchError((onError) {
          showSnackBar(context, "Upload not full successful");
          Navigator.pop(context);

          setState(() {
            _isLoading = false;
          });
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future uploadImages(docId) async {
    List images = [];
    for (int i = 0; i < academicImageList.length; i++) {
      if (kIsWeb) {
        Reference reference =
            FirebaseStorage.instance.ref().child("Applications/$docId/$i");
        await reference
            .putData(
          academicImageList[i],
          SettableMetadata(contentType: 'image/jpeg'),
        )
            .then((p0) async {
          images.add(await p0.ref.getDownloadURL());
        });
      } else {
        Reference reference =
            FirebaseStorage.instance.ref().child("Applications/$docId/$i");
        await reference
            .putData(
          academicImageList[i],
          SettableMetadata(contentType: 'image/jpeg'),
        )
            .then((p0) async {
          images.add(await p0.ref.getDownloadURL());
        });
      }
    }
    if (images.isEmpty) {
      showSnackBar(context, "Image failed to upload");
      return;
    }
    await applications.doc(docId).update({'images': images});
    showSnackBar(context, "Upload Successfully");
  }
}
