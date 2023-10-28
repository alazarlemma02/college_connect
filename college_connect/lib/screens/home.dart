import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connect/Screens/login.dart';
import 'package:college_connect/Screens/signup.dart';
import 'package:college_connect/screens/application_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/helper.dart';
import 'cart.dart';
import 'college.dart';
import 'my_college.dart';
import 'search.dart';
import 'widgets/drawer.dart';

bool _isLoading = false;
TextEditingController searchFieldController = TextEditingController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = getWidth(context);
    double height = getHeight(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ));
        }),
        backgroundColor: Colors.transparent,
        title: width > 320
            ? Text(
                title,
                style: const TextStyle(color: Colors.white),
              )
            : null,
        actions: [
          if (FirebaseAuth.instance.currentUser != null)
            Row(
              children: [
                if (usersData["type"] != "collegeAdmin")
                  SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      heroTag: "myColleges",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ));
                      },
                      label: const Text("My Colleges"),
                    ),
                  ),
                if (usersData["type"] == "collegeAdmin")
                  SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      heroTag: "myAdmin",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyCollegeScreen(),
                            ));
                      },
                      label: const Text("My Admin"),
                    ),
                  ),
                const SizedBox(
                  width: 10,
                ),
                if (usersData["type"] == "collegeAdmin")
                  SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      heroTag: "addColleges",
                      onPressed: () async => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CollegeScreen(),
                          )),
                      label: const Text("Add college"),
                    ),
                  ),
                const SizedBox(width: 10),
                if (usersData["type"] != "collegeAdmin")
                  SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      heroTag: "application",
                      onPressed: () async => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApplicationForm(),
                          )),
                      label: const Text("Application"),
                    ),
                  ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Good ${greeting()}",
                      style: const TextStyle(fontFamily: "bold"),
                    ),
                    if (usersData["firstName"] != null)
                      Text("${usersData["firstName"]}"),
                  ],
                ),
              ],
            )
          else
            Row(
              children: [
                TextButton(
                  child: const Text("Login"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                  },
                ),
                const SizedBox(width: 15),
                if (width > 320)
                  SizedBox(
                    height: 40,
                    child: FloatingActionButton.extended(
                      heroTag: "createAccount",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ));
                      },
                      label: const Text("Create account"),
                    ),
                  ),
              ],
            ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      drawer: MyWidgets().drawer(context),
      body: Container(
        height: height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg.jpg",
                ),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            StatefulBuilder(builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: (searchValue == null || searchValue!.isEmpty)
                      ? Colors.transparent
                      : Colors.grey.shade300.withOpacity(.4),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      children: [
                        Container(
                          width: 300,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            maxLines: 1,
                            controller: searchFieldController,
                            decoration: InputDecoration(
                                fillColor: Colors.white.withOpacity(.4),
                                filled: true,
                                isDense: true,
                                constraints:
                                    const BoxConstraints(maxHeight: 55),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(30, 15, 15, 15),
                                labelText: "Search for colleges",
                                suffix: IconButton(
                                  icon: const Icon(CupertinoIcons.search),
                                  onPressed: () {
                                    setState(() {
                                      searchValue =
                                          searchFieldController.text.trim();
                                    });
                                  },
                                )),
                            onSubmitted: (v) {
                              setState(() {
                                searchValue = v.trim();
                              });
                            },
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchScreen(),
                                ));
                          },
                          child: const Icon(Icons.filter_list_alt),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (searchValue != null && searchValue!.isNotEmpty)
                      SizedBox(
                        width: 600,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: colleges
                              .where('search',
                                  arrayContains:
                                      searchValue!.trim().toLowerCase())
                              .limit(15)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const SizedBox();
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox();
                            }

                            return Column(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ExpansionTile(
                                    collapsedShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor: Colors.grey.shade400,
                                    collapsedBackgroundColor:
                                        Colors.grey.shade400,
                                    title: Text("${data['name'] ?? 'unknown'}"),
                                    leading: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: SizedBox(
                                        // color: Colors.green,
                                        width: 50,
                                        height: 50,
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: Image.network(
                                                    data["images"][0],
                                                    fit: BoxFit.cover))),
                                      ),
                                    ),
                                    expandedAlignment: Alignment.centerLeft,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                '${data['description']}',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'semiBold',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                'Acceptance rate ${data['acceptanceRate'] ?? 'unknown'}',
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'semiBold',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                'Deadline ${data['deadline'] != null ? "${DateTime.fromMillisecondsSinceEpoch(data['deadline']).day} - ${DateTime.fromMillisecondsSinceEpoch(data['deadline']).month} - ${DateTime.fromMillisecondsSinceEpoch(data['deadline']).year}" : 'unknown'}',
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'semiBold',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'Website link',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: 'semiBold',
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (data['websiteLink'] !=
                                                          null) {
                                                        await launchUrl(Uri.parse(
                                                            "https://${data['websiteLink']}"));
                                                      }
                                                    },
                                                    child: Text(
                                                      '${data['websiteLink'] ?? 'unknown'}',
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontFamily: 'semiBold',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                'Address - ${data['address'] ?? 'unknown'}',
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'semiBold',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                'Phone number - ${data['phoneNumber'] ?? 'unknown'}',
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'semiBold',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                'Email - ${data['email'] ?? 'unknown'}',
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'semiBold',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                'Application fee - ${data['applicationFee'] ?? 'unknown'} Br',
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'semiBold',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return FloatingActionButton.extended(
                                            heroTag: "addToCart",
                                            onPressed: () async {
                                              if (!_isLoading) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                if (FirebaseAuth
                                                        .instance.currentUser !=
                                                    null) {
                                                  await users
                                                      .doc(uid())
                                                      .collection("cart")
                                                      .add({
                                                    "id": document.id,
                                                  }).then((value) {
                                                    cartItems.add({
                                                      "id": document.id,
                                                      "cid": value.id,
                                                    });
                                                    showSnackBar(context,
                                                        "College added to cart.");
                                                  }).catchError((e) {
                                                    showSnackBar(context,
                                                        "Failed to add product to your cart.");
                                                  });
                                                } else {
                                                  cartItems.add({
                                                    "id": document.id,
                                                    "cid": generateUid(5, 36),
                                                  });
                                                  showSnackBar(context,
                                                      "College added to cart");
                                                }

                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            },
                                            label: const Text(
                                                "Add to my college"));
                                      }),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(
              height: 15,
            ),
            if (usersData["type"] != "collegeAdmin")
              StreamBuilder<QuerySnapshot>(
                stream: colleges
                    .where('trend', isEqualTo: "1")
                    .limit(15)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const SizedBox();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }

                  return Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(.5)),
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.withOpacity(.5),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        data["images"][0],
                                      ))),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      '${data['description']}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'semiBold',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      'Acceptance rate ${data['acceptanceRate'] ?? 'unknown'}',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'semiBold',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      'Deadline ${data['deadline'] != null ? "${DateTime.fromMillisecondsSinceEpoch(data['deadline']).day} - ${DateTime.fromMillisecondsSinceEpoch(data['deadline']).month} - ${DateTime.fromMillisecondsSinceEpoch(data['deadline']).year}" : 'unknown'}',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'semiBold',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Wrap(
                                      children: [
                                        const Text(
                                          'Website link',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'semiBold',
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (data['websiteLink'] != null) {
                                              await launchUrl(Uri.parse(
                                                  "https://${data['websiteLink']}"));
                                            }
                                          },
                                          child: Text(
                                            '${data['websiteLink'] ?? 'unknown'}',
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'semiBold',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      'Address - ${data['address'] ?? 'unknown'}',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'semiBold',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      'Phone number - ${data['phoneNumber'] ?? 'unknown'}',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'semiBold',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      'Email - ${data['email'] ?? 'unknown'}',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'semiBold',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      'Application fee - ${data['applicationFee'] ?? 'unknown'} Br',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'semiBold',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  StatefulBuilder(builder: (context, setState) {
                                    return FloatingActionButton.extended(
                                        heroTag: "addToCart",
                                        onPressed: () async {
                                          if (!_isLoading) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            if (FirebaseAuth
                                                    .instance.currentUser !=
                                                null) {
                                              await users
                                                  .doc(uid())
                                                  .collection("cart")
                                                  .add({
                                                "id": document.id,
                                              }).then((value) {
                                                cartItems.add({
                                                  "id": document.id,
                                                  "cid": value.id,
                                                });
                                                showSnackBar(context,
                                                    "College added to cart.");
                                              }).catchError((e) {
                                                showSnackBar(context,
                                                    "Failed to add product to your cart.");
                                              });
                                            } else {
                                              cartItems.add({
                                                "id": document.id,
                                                "cid": generateUid(5, 36),
                                              });
                                              showSnackBar(context,
                                                  "College added to cart");
                                            }

                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        },
                                        label: const Text("Add to my college"));
                                  }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            const SizedBox(
              height: 50,
            ),
          ]),
        ),
      ),
    );
  }
}
