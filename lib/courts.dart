// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportsarena_app/courtBooking.dart';
import 'package:sportsarena_app/login.dart';

class Courts extends StatefulWidget {
  String sportType;

  Courts({super.key, required this.sportType});

  @override
  State<Courts> createState() => _CourtsState();
}

class _CourtsState extends State<Courts> {
  List<int> courtNum = <int>[1, 2, 3, 4];
  List<int> colorCodes = <int>[700, 500, 300, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.sportType),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.black,
              onPressed: () {
                signOut();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Center(
              child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Text(
                "CHOOSE YOUR COURT",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              itemCount: widget.sportType == "Badminton" ? courtNum.length : 2,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CourtBooking(
                                  courtNum: courtNum[index],
                                  sportType: widget.sportType,
                                )));
                  },
                  child: Container(
                    height: 100,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                        color: Colors.cyan[colorCodes[index]],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 6,
                            blurRadius: 7,
                            offset: Offset(2, 3),
                          ),
                        ]),
                    child: Center(
                        child: Text(
                      'Court ${courtNum[index]}',
                      style: TextStyle(fontSize: 30),
                    )),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ])),
        ));
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false);
  }
}
