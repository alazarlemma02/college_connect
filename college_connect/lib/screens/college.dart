// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/helper.dart';

bool _isLoading = false;

class CollegeScreen extends StatefulWidget {
  const CollegeScreen({super.key});
  @override
  State<CollegeScreen> createState() => _CollegeScreenState();
}

class _CollegeScreenState extends State<CollegeScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final applicationFeeController = TextEditingController();
  final collegeRequirementsController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? deadlineController;
  final acceptanceRateController = TextEditingController();
  final department = [];
  final pnController = TextEditingController();
  List<Uint8List> imageList = [];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double width = getWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Register new college",
            style: TextStyle(fontSize: 25, fontFamily: "bold"),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),

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
                        GestureDetector(
                          onTap: () async {
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

                    const SizedBox(
                      height: 15,
                    ),
                    //Name
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? 'College name required' : null,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          labelText: 'College Name',
                          labelStyle: TextStyle(fontFamily: 'light')),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? 'Last name required' : null,
                      controller: addressController,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(fontFamily: 'light')),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //Email
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your email' : null,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontFamily: 'RobotoLight')),
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
                          labelStyle: TextStyle(fontFamily: 'RobotoLight')),
                      keyboardType: TextInputType.phone,
                      maxLength: 9,
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        ).then((value) {
                          setState(() {
                            if (value != null) {
                              deadlineController = value;
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
                            child: Text(deadlineController == null
                                ? "Dead line"
                                : "${deadlineController!.day} - ${deadlineController!.month} -${deadlineController!.year}"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? 'Acceptance rate' : null,
                      controller: acceptanceRateController,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          labelText: 'Acceptance rate',
                          labelStyle: TextStyle(fontFamily: 'RobotoLight')),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? 'Website link is required' : null,
                      controller: websiteController,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          labelText: 'Website link',
                          labelStyle: TextStyle(fontFamily: 'RobotoLight')),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? 'Description is required' : null,
                      controller: descriptionController,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(fontFamily: 'RobotoLight')),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? 'Application fee' : null,
                      controller: applicationFeeController,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          labelText: 'Application fee',
                          suffixText: "Br",
                          labelStyle: TextStyle(fontFamily: 'RobotoLight')),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    ListTile(
                      title: const Text(
                        "Department",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: department.isNotEmpty
                            ? SizedBox(
                                height: 50,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: department.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onLongPress: () {
                                              setState(() {
                                                department.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 250),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              decoration: BoxDecoration(
                                                color: Colors.pink.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SelectableText(
                                                    department[index]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: "semiBold"),
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      );
                                    }),
                              )
                            : const Text("No department added"),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          TextEditingController vTitleController =
                              TextEditingController();
                          showDialog(
                            context: context,
                            builder: (builder) => AlertDialog(
                              content: SizedBox(
                                height: 150,
                                width: width < 1000 ? width - 50 : 500,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: TextFormField(
                                    controller: vTitleController,
                                    cursorColor: Colors.black,
                                    style: const TextStyle(color: Colors.black),
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText: 'Title',
                                    ),
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Add'),
                                  onPressed: () {
                                    if (vTitleController.text
                                        .trim()
                                        .isNotEmpty) {
                                      setState(() {
                                        department
                                            .add(vTitleController.text.trim());
                                      });
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    button(),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  button() {
    return StatefulBuilder(builder: (context, setState) {
      return FloatingActionButton.extended(
        onPressed: !_isLoading
            ? () async {
                setState(() {
                  _isLoading = true;
                });
                if (_formKey.currentState!.validate()) {
                  if (department.isEmpty) {
                    showSnackBar(context, "Please add at least 1 department");
                    setState(() {
                      _isLoading = false;
                    });
                  }
                  if (imageList.isEmpty) {
                    showSnackBar(context, "Please add at least 1 image");
                    setState(() {
                      _isLoading = false;
                    });
                  } else {
                    var array = [];
                    String c = nameController.text.trim().toLowerCase();
                    for (int i = 1; i < c.length + 1; i++) {
                      array.add(c.substring(0, i));
                    }
                    colleges.add({
                      'name': nameController.text.trim(),
                      'email': emailController.text.trim().toLowerCase(),
                      'timeStamp': FieldValue.serverTimestamp(),
                      'lastUpdate': {
                        "timeStamp": FieldValue.serverTimestamp(),
                        "by": uid()
                      },
                      if (applicationFeeController.text.isNotEmpty)
                        'applicationFee': applicationFeeController.text,
                      if (websiteController.text.isNotEmpty)
                        'websiteLink': websiteController.text,
                      if (pnController.text.isNotEmpty)
                        'phoneNumber': int.parse(pnController.text),
                      if (addressController.text.isNotEmpty)
                        'address': addressController.text.trim().toLowerCase(),
                      if (acceptanceRateController.text.isNotEmpty)
                        'acceptanceRate':
                            acceptanceRateController.text.trim().toLowerCase(),
                      if (descriptionController.text.isNotEmpty)
                        'description': descriptionController.text,
                      if (deadlineController != null)
                        'deadline': deadlineController!.millisecondsSinceEpoch,
                      'department': department,
                      if (websiteController.text.isEmpty)
                        'websiteLink':
                            websiteController.text.trim().toLowerCase(),
                      'search': array,
                      'owner': uid(),
                    }).then((value) async {
                      await uploadImages(value.id);
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pop(context);
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
            : null,
        backgroundColor: Colors.blue,
        label: !_isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.cloud_upload,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Upload",
                    style: TextStyle(color: Colors.white, fontFamily: 'bold'),
                  )
                ],
              )
            : const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 1.5,
                  ),
                ),
              ),
      );
    });
  }

  Future uploadImages(docId) async {
    List images = [];
    for (int i = 0; i < imageList.length; i++) {
      if (kIsWeb) {
        Reference reference =
            FirebaseStorage.instance.ref().child("Colleges/$docId/$i");
        await reference
            .putData(
          imageList[i],
          SettableMetadata(contentType: 'image/jpeg'),
        )
            .then((p0) async {
          images.add(await p0.ref.getDownloadURL());
        });
      } else {
        Reference reference =
            FirebaseStorage.instance.ref().child("Colleges/$docId/$i");
        await reference
            .putData(
          imageList[i],
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
    await colleges.doc(docId).update({'images': images});
    showSnackBar(context, "Updated Successfully");
  }
}
