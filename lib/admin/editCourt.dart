// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportsarena_app/courtBooking.dart';
import 'package:sportsarena_app/model/court.dart';

List<bool> avaiList = <bool>[true, false];

class EditCourt extends StatefulWidget {
  Court court;
  EditCourt({super.key, required this.court});

  @override
  State<EditCourt> createState() => _EditCourtState();
}

class _EditCourtState extends State<EditCourt> {
  TextEditingController courtNumController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String sportTypeValue = "";
  String timeValue = "";
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    sportTypeValue = widget.court.sportType;
    timeValue = widget.court.time;
    isAvailable = widget.court.availability;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Text(
                "Edit Court",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Time : $timeValue",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "Court Number : ${widget.court.courtNum}",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Sport Type : $sportTypeValue",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    width: 110,
                    height: 40,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController
                        ..text = widget.court.price.toString(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Price',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DropdownButton<bool>(
              value: isAvailable,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.teal),
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              onChanged: (bool? value) {
                setState(() {
                  isAvailable = value!;
                });
              },
              items: avaiList.map<DropdownMenuItem<bool>>((bool value) {
                return DropdownMenuItem<bool>(
                  value: value,
                  child: value ? Text("Available") : Text("Booked"),
                );
              }).toList(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40),
              child: SizedBox(
                height: 50,
                width: 370,
                child: ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () {
                      editCourt(widget.court);
                      print(courtNumController.text);
                    }),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40),
              child: Container(
                decoration: BoxDecoration(color: Colors.red),
                height: 50,
                width: 370,
                child: ElevatedButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      deleteCourt(widget.court);
                      print(courtNumController.text);
                    }),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  var snackBarSuccess = SnackBar(
    backgroundColor: Colors.green,
    content: Text('Update Success!'),
  );
  var snackBarDeleteSuccess = SnackBar(
    backgroundColor: Colors.green,
    content: Text('Delete Success!'),
  );

  var snackBarFail = SnackBar(
    backgroundColor: Colors.redAccent,
    content: Text('Update Failed!'),
  );

  var snackBarDeleteFail = SnackBar(
    backgroundColor: Colors.redAccent,
    content: Text('Delete Failed!'),
  );

  Future editCourt(Court court) async {
    try {
      FirebaseFirestore.instance
          .collection("courts")
          .doc(court.courtID)
          .update({
        "availability": isAvailable,
        "price": int.parse(priceController.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);

    } on FirebaseException catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(snackBarFail);
    }
  }

  Future deleteCourt(Court court) async {
    try {
      FirebaseFirestore.instance
          .collection("courts")
          .doc(court.courtID)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(snackBarDeleteSuccess);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CourtBooking(
                  courtNum: court.courtNum,
                  sportType: court.sportType,
                )),
      );
    } on FirebaseException catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(snackBarDeleteFail);
    }
  }
}
