import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_connect/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Map college = {};
bool _isLoading = false;

class ApplicantScreen extends StatefulWidget {
  const ApplicantScreen({super.key});
  @override
  State<ApplicantScreen> createState() => _ApplicantScreenState();
}

class _ApplicantScreenState extends State<ApplicantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: applications
            .where("collegeId", isEqualTo: college["id"])
            .limit(15)
            .snapshots(),
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
                              'Name: ${data['fullName']}',
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
                              'Email ${data['email'] ?? 'unknown'}',
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
                              'Essay ${data['essay'] ?? 'unknown'}',
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
                            child: Text(
                              'Graduation date:  ${data['graduationDate'] ?? 'unknown'}',
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
                              'High school name - ${data['schoolName'] ?? 'unknown'}',
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
                              'GPA - ${data['gpa'] ?? 'unknown'} Br',
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 17,
                                fontFamily: 'semiBold',
                              ),
                            ),
                          ),
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
