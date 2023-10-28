import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helpers/helper.dart';

List cartItems = [];
bool gotCart = false;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: gotCart
          ? ListView(
              padding: const EdgeInsets.only(bottom: 70),
              children: [
                for (var item in cartItems)
                  Builder(builder: (context) {
                    return Dismissible(
                      onDismissed: (v) async {
                        setState(() {
                          cartItems.remove(item);
                        });
                        if (item["cid"] != null) {
                          await users
                              .doc(uid())
                              .collection("cart")
                              .doc(item["cid"])
                              .delete();
                        }
                      },
                      background: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                      key: GlobalKey(),
                      child: Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: 2,
                                    blurRadius: 5)
                              ],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              )),
                          child: FutureBuilder(
                              future: colleges.doc(item["id"]).get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var data = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  return Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    data["images"][0]),
                                                fit: BoxFit.cover,
                                                alignment:
                                                    const Alignment(0, -.3))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          "${data["name"] ?? "untitled"}\naddress: ${data["address"] ?? "unknown"}",
                                          maxLines: 2,
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      Container(
                                          height: 100,
                                          width: 100,
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          )),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          "...",
                                          maxLines: 1,
                                        ),
                                      )
                                    ],
                                  );
                                }
                              })),
                    );
                  }),
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
                          style:
                              TextStyle(fontSize: 20, fontFamily: "semiBold"),
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
                  ),
              ],
            )
          : const Center(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  )),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
      setState(() {
        gotCart = true;
      });
    }
  }
}
