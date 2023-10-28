import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/helper.dart';
import 'cart.dart';

String? searchValue;
bool _isLoading = false;
List<String> filters = ["Name", "Department", "Address", "Acceptance Rate"];
String? filterBy = "Name";

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    double width = getWidth(context);
    double height = getHeight(context);
    bool isLandscape = getOrientation(context);

    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            height: 240,
            width: width,
            decoration: const BoxDecoration(
              color: Color(0xff8c84cb),
              // color: Colors.green,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Search",
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'bold', fontSize: 20)),
                const Text("Colleges",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'semiBold',
                      fontSize: 15,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 20,
                  children: [
                    SizedBox(
                      width: width > 720 ? width - 300 : width,
                      child: TextField(
                        maxLines: 1,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            constraints: const BoxConstraints(maxHeight: 50),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Search",
                            prefixIcon: const Icon(CupertinoIcons.search)),
                        onChanged: (v) {
                          setState(() {
                            searchValue = v.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButton(
                        value: filterBy,
                        onChanged: (value) {
                          setState(() {
                            filterBy = value.toString();
                          });
                        },
                        borderRadius: BorderRadius.circular(15),

                        // menuStyle: MenuStyle(
                        //     backgroundColor: MaterialStateColor.resolveWith(
                        //         (states) => Colors.white),
                        //     side: MaterialStateBorderSide.resolveWith(
                        //         (states) =>
                        //             const BorderSide(color: Colors.white))),
                        items: filters
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toString()),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // Container(
                //   decoration: const BoxDecoration(
                //     color: Colors.yellow,
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //   ),
                //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   child: const Text('Hello',style: TextStyle(color: Colors.black),),
                // ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                Text(searchValue != null ? "Search result" : "Suggestion",
                    style: const TextStyle(
                        color: Color(0xff736bb7),
                        fontFamily: 'bold',
                        fontSize: 20)),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: filterStream(filterBy!),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width * .42,
                            height: width * .42,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: isLandscape ? height * .3 : width * .3,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: isLandscape ? height * .3 : width * .3,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ],
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ExpansionTile(
                        collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.grey.shade100,
                        collapsedBackgroundColor: Colors.grey.shade400,
                        leading: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                              // color: Colors.green,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        expandedAlignment: Alignment.centerLeft,
                        title: const SizedBox(),
                      );
                    }

                    return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ExpansionTile(
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Colors.grey.shade400,
                            collapsedBackgroundColor: Colors.grey.shade400,
                            title: Text("${data['name'] ?? 'unknown'}"),
                            leading: Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                // color: Colors.green,
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Image.network(data["images"][0],
                                            fit: BoxFit.cover))),
                              ),
                            ),
                            expandedAlignment: Alignment.centerLeft,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
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
                                  ],
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
                                        if (FirebaseAuth.instance.currentUser !=
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
                                          showSnackBar(
                                              context, "College added to cart");
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
                        );
                      }).toList(),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Stream<QuerySnapshot> filterStream(String filterBy) {
  if (searchValue == null) {
    return colleges.where('trend', isEqualTo: "1").limit(15).snapshots();
  }
  switch (filterBy) {
    case ("Name"):
      return colleges
          .where('search', arrayContains: searchValue!.trim().toLowerCase())
          .limit(15)
          .snapshots();
    case ("Department"):
      return colleges
          .where('department', arrayContains: searchValue!.trim().toLowerCase())
          .limit(15)
          .snapshots();
    case ("Address"):
      return colleges
          .where('address', isEqualTo: searchValue!.trim().toLowerCase())
          .limit(15)
          .snapshots();
    case ("Acceptance Rate"):
      return colleges
          .where('acceptanceRate', isEqualTo: searchValue!.trim().toLowerCase())
          .limit(15)
          .snapshots();
    default:
      return colleges.where('trend', isEqualTo: "1").limit(15).snapshots();
  }
}
