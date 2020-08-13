class AvailableCurrency {
  int id;
  String abbr;

  AvailableCurrency(this.id, this.abbr);

  AvailableCurrency.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        abbr = json['abbr'];

  AvailableCurrency.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.abbr = map['abbr'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'abbr': abbr};

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['abbr'] = abbr;

    return map;
  }
}
