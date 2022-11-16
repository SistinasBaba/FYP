// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<String> sportList = <String>['Badminton', 'Futsal'];
List<String> timeList = <String>[
  '01:00',
  '02:00',
  '03:00',
  '04:00',
  '05:00',
  '06:00',
  '07:00',
  '08:00',
  '09:00',
  '10:00',
  '11:00',
  '12:00',
  '13:00',
  '14:00',
  '15:00',
  '16:00',
  '17:00',
  '18:00',
  '19:00',
  '20:00',
  '21:00',
  '22:00',
  '23:00',
  '00:00'
];

class AddCourt extends StatefulWidget {
  const AddCourt({super.key});

  @override
  State<AddCourt> createState() => _AddCourtState();
}

class _AddCourtState extends State<AddCourt> {
  TextEditingController courtNumController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String sportTypeValue = sportList.first;
  String timeValue = timeList.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Courts"),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Text(
                "Add Court",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Time :",
                  style: TextStyle(fontSize: 17),
                ),
                DropdownButton<String>(
                  value: timeValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.teal),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      timeValue = value!;
                    });
                  },
                  items: timeList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Text(
                  "Court Number :",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  // padding: const EdgeInsets.all(10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: courtNumController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Sport Type :",
                  style: TextStyle(fontSize: 17),
                ),
                DropdownButton<String>(
                  value: sportTypeValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 1,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      sportTypeValue = value!;
                    });
                  },
                  items:
                      sportList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  // padding: const EdgeInsets.all(10),
                  width: 110,
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter price',
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40),
              child: SizedBox(
                height: 50,
                width: 370,
                child: ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () {
                      addCourt(sportTypeValue);
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
    content: Text('Add Success!'),
  );

  var snackBarFail = SnackBar(
    backgroundColor: Colors.redAccent,
    content: Text('Add Failed!'),
  );

  Future addCourt(String sportTypeValue) async {
    try {
      QuerySnapshot court = await FirebaseFirestore.instance
          .collection("courts")
          .where("courtNum", isEqualTo: int.parse(courtNumController.text))
          .where("sportType", isEqualTo: sportTypeValue)
          .where("time", isEqualTo: timeValue)
          .get();

      if (court.docs.isEmpty) {
        DocumentReference newCourt =
            await FirebaseFirestore.instance.collection("courts").add({
          'courtNum': int.parse(courtNumController.text),
          'price': int.parse(priceController.text),
          'availability': true,
          'sportType': sportTypeValue,
          'time': timeValue,
        });
        FirebaseFirestore.instance
            .collection("courts")
            .doc(newCourt.id)
            .update({
          "courtID": newCourt.id,
        });
        ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);

        courtNumController.clear();
        priceController.clear();
        timeValue = timeList.first;
        sportTypeValue = sportList.first;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBarFail);
      }
    } on FirebaseException catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(snackBarFail);
    }
  }
}
