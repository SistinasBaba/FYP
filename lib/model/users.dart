class Users {
  String _name;
  String _email;
  String _phoneNum;
  String _userID;
  bool _isAdmin;

  get name => _name;
  get email => _email;
  get phoneNum => _phoneNum;
  get userID => _userID;
  get isAdmin => _isAdmin;

  Users({
    String name = '',
    String email = '',
    String phoneNum = '',
    String userID = "",
    bool isAdmin = true,
  })  : _name = name,
        _email = email,
        _phoneNum = phoneNum,
        _userID = userID,
        _isAdmin = isAdmin;

  Users.fromJson(Map<String, dynamic> map)
      : _name = map['name'],
        _email = map['email'],
        _phoneNum = map['phoneNum'],
        _userID = map['userID'],
        _isAdmin = map['isAdmin'];

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'email': _email,
      'phoneNum': _phoneNum,
      'userID': _userID,
      'isAdmin': _isAdmin,
    };
  }
}
