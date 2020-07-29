class User {
  // ignore: non_constant_identifier_names
  String first_name;

  // ignore: non_constant_identifier_names
  String last_name;
  String email;
  String username;
  String password;
  String photoUrl;

  User(this.first_name, this.last_name, this.email, this.username,
      this.password, this.photoUrl);

  User.fromJson(Map<String, dynamic> json)
      : first_name = json['first_name'],
        last_name = json['last_name'],
        email = json['email'],
        username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'username': username,
        'password': password
      };
}
