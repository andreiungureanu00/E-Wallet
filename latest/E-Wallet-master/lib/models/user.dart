class User {
  // ignore: non_constant_identifier_names
  String first_name;

  // ignore: non_constant_identifier_names
  String last_name;
  String email;
  String username;
  String password;
  String photoUrl;
  int authCode;

  User(this.first_name, this.last_name, this.email, this.username,
      this.password, this.photoUrl, this.authCode);

  User.fromJson(Map<String, dynamic> json)
      : first_name = json['first_name'],
        last_name = json['last_name'],
        email = json['email'],
        username = json['username'],
        password = json['password'],
        photoUrl = json['photoUrl'],
        authCode = json['authCode'];

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['last_name'] = last_name;
    map['email'] = email;
    map['username'] = username;
    map['password'] = password;
    map['photoUrl'] = photoUrl;
    map['authCode'] = authCode;

    return map;
  }

  User.fromMapObject(Map<String, dynamic> map) {
    this.last_name = map['last_name'];
    this.email = map['email'];
    this.username = map['username'];
    this.password = map['password'];
    this.photoUrl = map['photoUrl'];
    this.authCode = map['authCode'];
  }

  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'username': username,
        'password': password,
        'photoUrl': photoUrl,
        'authCode': authCode
      };
}
