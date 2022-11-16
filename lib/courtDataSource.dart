// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportsarena_app/admin/editCourt.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'model/court.dart';

class CourtDataSource extends DataGridSource {
  CourtDataSource(this.courtData, this.context) {
    _buildDataRow();
  }
  BuildContext context;

  List<DataGridRow> _courtData = [];
  List<Court> courtData;

  void _buildDataRow() {
    _courtData = courtData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'time', value: e.time),
              DataGridCell<int>(columnName: 'price', value: e.price),
              DataGridCell<bool>(
                  columnName: 'availability', value: e.availability),
              DataGridCell<String>(columnName: 'courtID', value: e.courtID),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _courtData;
  List<DataGridRow> get selectedRows => _courtData;

  @override
  DataGridRowAdapter buildRow(
    DataGridRow row,
  ) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: e.columnName == "courtID"
            ? GestureDetector(
                onTap: () async {
                  Court tempCourt = await _getCourt(e.value.toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditCourt(court: tempCourt)));
                },
                child: Icon(
                  Icons.edit,
                ),
              )
            : e.value == true
                ? Text("Available")
                : e.value == false
                    ? Text("Booked")
                    : Text(e.value.toString()),
      );
    }).toList());
  }
}

Future<Court> _getCourt(String court) async {
  Court tempCourt = Court();
  try {
    DocumentSnapshot c =
        await FirebaseFirestore.instance.collection("courts").doc(court).get();
    tempCourt = Court.fromJson(c.data() as Map<String, dynamic>);
    return tempCourt;
  } on FirebaseException catch (e) {
    rethrow;
  }
}
