import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connect/screens/applicant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/helper.dart';

bool _isLoading = false;

class MyCollegeScreen extends StatefulWidget {
  const MyCollegeScreen({super.key});

  @override
  State<MyCollegeScreen> createState() => _MyCollegeScreenState();
}

class _MyCollegeScreenState extends State<MyCollegeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: colleges.where("owner", isEqualTo: uid()).limit(15).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(10),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                        heroTag: "applicants",
                        onPressed: () async {
                          if (!_isLoading) {
                            setState(() {
                              _isLoading = true;
                            });
                            college.clear();
                            college.addEntries({
                              "id": document.id,
                            }.entries);
                            college.addAll(data);
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
    ));
  }
}
