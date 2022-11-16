// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportsarena_app/checkout.dart';
import 'package:sportsarena_app/courts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'admin/addCourt.dart';
import 'model/court.dart';
import 'courtDataSource.dart';
import 'model/users.dart';

class CourtBooking extends StatefulWidget {
  int courtNum;
  String sportType;

  CourtBooking({super.key, required this.courtNum, required this.sportType});

  @override
  State<CourtBooking> createState() => _CourtBookingState();
}

class _CourtBookingState extends State<CourtBooking> {
  DataGridController _dataGridController = DataGridController();
  List<Court> courtList = [];
  late CourtDataSource courtDataSource;
  Users currUser = Users();
  bool isVisible = false;
  bool isShowCheckBox = true;
  bool isAddCourt = false;
  List<String> selectedCourts = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.sportType} Court Booking"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            getCurrentUser();
          });
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Text(
              isAddCourt ? 'LIST OF TIME' : 'CHOOSE THE AVALAIBLE TIME',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            )),
          ),
          FutureBuilder(
              future: getCourt(widget.courtNum),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return SfDataGrid(
                    columnWidthMode: ColumnWidthMode.fill,
                    controller: _dataGridController,
                    source: courtDataSource,
                    showCheckboxColumn: isShowCheckBox,
                    selectionMode: isShowCheckBox
                        ? SelectionMode.multiple
                        : SelectionMode.none,
                    columns: <GridColumn>[
                      GridColumn(
                          columnName: 'time',
                          label: Container(
                              padding: EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Time',
                              ))),
                      GridColumn(
                          columnName: 'price',
                          label: Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text('Price (RM)'))),
                      GridColumn(
                          columnName: 'availability',
                          label: Container(
                              padding: EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Availability',
                                overflow: TextOverflow.ellipsis,
                              ))),
                      GridColumn(
                          visible: isVisible,
                          columnName: 'courtID',
                          label: Container(
                            padding: EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                          )),
                    ],
                  );
                }
              }),
        ]),
      ),
      floatingActionButton: isAddCourt
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                    heroTag: 'btn1',
                    backgroundColor: Colors.teal[900],
                    label: Text('Reset Availability'),
                    onPressed: (() {
                      setState(() {
                        resetAvailability();
                        getCourt(widget.courtNum);
                      });
                    })),
                FloatingActionButton.extended(
                    heroTag: 'btn2',
                    label: Text('Add new Court'),
                    onPressed: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCourt()),
                      );
                    })),
              ],
            )
          : FloatingActionButton.extended(
              heroTag: 'btn3',
              label: Text('Check Out'),
              onPressed: (() {
                selectedCourts.clear();
                for (var element in _dataGridController.selectedRows) {
                  print(element.getCells()[3].value);
                  if (element.getCells()[2].value == true) {
                    selectedCourts.add(element.getCells()[3].value);
                  } else {
                    selectedCourts.clear();
                    break;
                  }
                }

                if (selectedCourts.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckOut(
                            selectedCourts: selectedCourts,
                            sportType: widget.sportType,
                            currUser: currUser)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(snackBarFail);
                }
              })),
    );
  }

  var snackBarFail = SnackBar(
    backgroundColor: Colors.redAccent,
    content: Text('Please choose available time!'),
  );

  Future<void> getCurrentUser() async {
    try {
      var userCredential = FirebaseAuth.instance.currentUser;
      DocumentSnapshot user = await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential!.uid)
          .get();
      currUser = Users.fromJson(user.data() as Map<String, dynamic>);

      if (currUser.isAdmin) {
        setState(() {
          isVisible = true;
          isShowCheckBox = false;
          isAddCourt = true;
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  Future<List<Court>> getCourt(int courtNum) async {
    courtList.clear();
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("courts")
          .where("courtNum", isEqualTo: courtNum)
          .where("sportType", isEqualTo: widget.sportType)
          .orderBy("time")
          .get();

      for (var element in querySnapshot.docs) {
        courtList.add(Court.fromJson(element.data() as Map<String, dynamic>));
      }

      courtDataSource = CourtDataSource(courtList, context);
      return courtList;
    } on FirebaseException catch (e) {
      print(e.message);

      rethrow;
    }
  }
}

Future<void> resetAvailability() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("courts").get();

  for (var element in querySnapshot.docs) {
    element.reference.update(<String, dynamic>{
      "availability": true,
    });
  }
}
