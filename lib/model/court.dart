class Court {
  String _courtID;
  int _courtNum;
  int _price;
  String _time;
  String _sportType;
  bool _availability;

  get courtID => _courtID;
  get courtNum => _courtNum;
  get price => _price;
  get time => _time;
  get sportType => _sportType;
  get availability => _availability;

  Court({
    String courtID = '',
    int courtNum = 0,
    int price = 0,
    String time = '',
    String sportType = '',
    bool availability = true,
  })  : _courtID = courtID,
        _courtNum = courtNum,
        _price = price,
        _time = time,
        _sportType = sportType,
        _availability = availability;

  Court.fromJson(Map<String, dynamic> map)
      : _courtID = map['courtID'],
        _courtNum = map['courtNum'],
        _price = map['price'],
        _time = map['time'],
        _sportType = map['sportType'],
        _availability = map['availability'];

  Map<String, dynamic> toJson() {
    return {
      'courtID': _courtID,
      'courtNum': _courtNum,
      'price': _price,
      'time': _time,
      'sportType': _sportType,
      'availability': _availability,
    };
  }
}
