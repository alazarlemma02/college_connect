import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _searchValue;

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
                const Text("Products",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'semiBold',
                      fontSize: 15,
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
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
                      _searchValue = v.trim();
                    });
                  },
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
                Text(_searchValue != null ? "Search result" : "Suggestion",
                    style: const TextStyle(
                        color: Color(0xff736bb7),
                        fontFamily: 'bold',
                        fontSize: 20)),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _searchValue != null
                      ? colleges
                          .where('search',
                              arrayContains: _searchValue!.trim().toLowerCase())
                          .limit(15)
                          .snapshots()
                      : colleges.where('trend', isEqualTo: "4").snapshots(),
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

                    return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            product = data;
                            // ignore: unnecessary_cast
                            product.addAll(
                                {"id": document.id} as Map<dynamic, dynamic>);
                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const DetailScreen()));
                          },
                          child: Container(
                            width: width,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(5, 5),
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: GestureDetector(
                              child: Row(
                                children: [
                                  if (data['images'] is List)
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: SizedBox(
                                        // color: Colors.green,
                                        width: 100,
                                        height: 100,
                                        child: Hero(
                                          tag: "pImage",
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                              child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: Image.network(
                                                      data["images"][0],
                                                      fit: BoxFit.cover))),
                                        ),
                                      ),
                                    ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Hero(
                                        tag: 'pTitle',
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            '${data['title'] ?? 'untitled'}',
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'semiBold',
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Hero(
                                        tag: 'pPrice',
                                        child: Wrap(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            const Text(
                                              'Br',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontFamily: 'light',
                                              ),
                                            ),
                                            Text(
                                              '${data['price']}',
                                              style: TextStyle(
                                                  color: data['discount'] !=
                                                          null
                                                      ? Colors.blue
                                                      : Colors.black,
                                                  fontSize: 17,
                                                  fontFamily:
                                                      data['discount'] != null
                                                          ? 'light'
                                                          : 'semiBold',
                                                  decoration:
                                                      data['discount'] != null
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration
                                                              .none),
                                            ),
                                            if (data['discount'] != null)
                                              Text(
                                                '${data['discount']}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontFamily: 'semiBold'),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
