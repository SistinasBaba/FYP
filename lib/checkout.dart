// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportsarena_app/model/users.dart';
import 'package:sportsarena_app/payment.dart';
import 'model/court.dart';
import 'model/booking.dart';

class CheckOut extends StatefulWidget {
  List<String> selectedCourts;
  String sportType;
  Users currUser;

  CheckOut(
      {super.key,
      required this.selectedCourts,
      required this.sportType,
      required this.currUser});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  List<Court> courtList = [];
  int totalPrice = 0;
  late Booking booking;

  @override
  void initState() {
    super.initState();
    courtList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Out"),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              "CONFIRM YOUR BOOKING",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController..text = widget.currUser.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: phoneNumController..text = widget.currUser.phoneNum,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone number',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(width: 2, color: Colors.teal))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text("No."),
                Text("Time"),
                Text("Court No."),
                Text("Price"),
              ],
            ),
          ),
          FutureBuilder(
              future: getSport(widget.selectedCourts),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: courtList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text((index + 1).toString()),
                              Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: Text(courtList[index].time),
                              ),
                              Text((courtList[index].courtNum).toString()),
                              Text((courtList[index].price).toString()),
                            ],
                          ),
                        );
                      });
                }
              }),
          Container(
              margin: EdgeInsets.only(left: 150),
              height: 50,
              width: 230,
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(width: 2, color: Colors.teal))),
              child: Text(
                "Total Price : RM ${totalPrice}",
                style: TextStyle(fontSize: 25),
              )),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text('Confirm and pay'),
          onPressed: (() async {
            booking = await addBooking(widget.selectedCourts, totalPrice);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Payment(
                        booking: booking,
                        currUser: widget.currUser,
                      )),
            );
          })),
    );
  }

  Future<List<Court>> getSport(List<String> id) async {
    courtList.clear();
    totalPrice = 0;

    try {
      for (int i = 0; i < id.length; i++) {
        DocumentSnapshot court = await FirebaseFirestore.instance
            .collection("courts")
            .doc(id[i])
            .get();
        courtList.add(Court.fromJson(court.data() as Map<String, dynamic>));
        totalPrice += courtList[i].price as int;
      }
        print(courtList.length);
        print(totalPrice);
        return courtList;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<Booking> addBooking(List<String> courts, int totalPrice) async {
    try {
      DocumentReference newBooking = await FirebaseFirestore.instance
          .collection("bookings")
          .add(Booking(
                  bookingID: '',
                  courtID: courts,
                  totalPrice: totalPrice,
                  userID: '')
              .toJson());

      FirebaseFirestore.instance
          .collection("bookings")
          .doc(newBooking.id)
          .update({
        "bookingID": newBooking.id,
        "userID": FirebaseAuth.instance.currentUser!.uid,
      });

      DocumentSnapshot booking = await FirebaseFirestore.instance
          .collection("bookings")
          .doc(newBooking.id)
          .get();

      for (int i = 0; i < courts.length; i++) {
        FirebaseFirestore.instance.collection("courts").doc(courts[i]).update({
          "availability": false,
        });
      }

      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.currUser.userID)
          .update({
        "name": nameController.text,
        "phoneNum": phoneNumController.text,
      });

      return Booking.fromJson(booking.data() as Map<String, dynamic>);
    } on FirebaseException {
      rethrow;
    }
  }
}
