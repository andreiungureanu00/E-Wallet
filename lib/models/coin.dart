class Coin {
  int id;
  String name;
  String abbr;
  int bank;
  // ignore: non_constant_identifier_names
  double rate_sell;
  // ignore: non_constant_identifier_names
  double rate_buy;

  Coin(this.id, this.name, this.abbr, this.bank, this.rate_sell, this.rate_buy);

  Coin.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        abbr = json['abbr'],
        bank = json['bank'];

  Coin.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.abbr = map['abbr'];
    this.bank = map['bank'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'abbr': abbr,
        'bank': bank,
      };

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['abbr'] = abbr;
    map['bank'] = bank;

    return map;
  }
}
