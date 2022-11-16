// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportsarena_app/home.dart';
import 'package:sportsarena_app/model/booking.dart';
import 'package:sportsarena_app/model/court.dart';
import 'package:sportsarena_app/model/users.dart';

class Payment extends StatefulWidget {
  Booking booking;
  Users currUser;
  Payment({super.key, required this.booking, required this.currUser});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
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
        title: Text(""),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              "PAYMENT SUCCESS",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("Booking Id : "),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("Name : "),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text("Phone Number"),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(widget.booking.bookingID),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(widget.currUser.name),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(widget.currUser.phoneNum),
                  ),
                ],
              ),
            ],
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
              future: getSport(widget.booking.courtID),
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
          label: Text('Go back home'),
          onPressed: (() async {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
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
}
