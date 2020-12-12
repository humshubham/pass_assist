class Password {
  int _id;
  String _title;
  String _username;
  String _password;

  Password(this._title, this._username, this._password);
  Password.withId(this._id, this._title, this._username, this._password);

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  // Used to save and Retrive from DataBase

  // Converts Password Object To Map Object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['username'] = _username;
    map['password'] = _password;

    return map;
  }

  Password.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._username = map['username'];
    this._password = map['password'];
  }
}
