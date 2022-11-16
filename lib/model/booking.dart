// ignore_for_file: equal_keys_in_map

class Booking {
  String _bookingID;
  int _totalPrice;
  List<String>? _courtID;
  String _userID;

  get bookingID => _bookingID;
  get totalPrice => _totalPrice;
  get courtID => _courtID;
  get userID => _userID;

  Booking({
    String bookingID = '',
    int totalPrice = 0,
    List<String>? courtID,
    String userID = '',
  })  : _bookingID = bookingID,
        _totalPrice = totalPrice,
        _courtID = courtID,
        _userID = userID;

  Booking.fromJson(Map<String, dynamic> map)
      : _bookingID = map['bookingID'],
        _totalPrice = map['totalPrice'],
        _courtID = List<String>.from(map['courtID']),
        _userID = map['userID'];

  Map<String, dynamic> toJson() {
    return {
      'bookingID': _bookingID,
      'totalPrice': _totalPrice,
      'courtID': _courtID,
      'userID': _userID,
    };
  }
}
