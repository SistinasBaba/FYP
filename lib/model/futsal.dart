import 'package:cloud_firestore/cloud_firestore.dart';

class Futsal {
  String _courtID;
  int _courtNum;
  int _price;
  String _time;
  bool _availability;

  get courtID => _courtID;
  get courtNum => _courtNum;
  get price => _price;
  get time => _time;
  get availability => _availability;

  Futsal({
    String courtID = '',
    int courtNum = 0,
    int price = 0,
    String time = '',
    bool availability = true,
  })  : _courtID = courtID,
        _courtNum = courtNum,
        _price = price,
        _time = time,
        _availability = availability;

  Futsal.fromJson(Map<String, dynamic> map)
      : _courtID = map['courtID'],
        _courtNum = map['courtNum'],
        _price = map['price'],
        _time = map['time'],
        _availability = map['availability'];

  Map<String, dynamic> toJson() {
    return {
      'courtID': _courtID,
      'courtNum': _courtNum,
      'price': _price,
      'time': _time,
      'availability': _availability,
    };
  }
}
