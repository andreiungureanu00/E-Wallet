class Bank {
  int id;

  // ignore: non_constant_identifier_names
  String registered_name;

  // ignore: non_constant_identifier_names
  String short_name;
  String website;

  Bank(this.id, this.registered_name, this.short_name, this.website);

  Bank.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        registered_name = json['registered_name'],
        short_name = json['short_name'],
        website = json['website'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'registered_name': registered_name,
        'short_name': short_name,
        'website': website,
      };

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['registered_name'] = registered_name;
    map['short_name'] = short_name;

    return map;
  }
}
