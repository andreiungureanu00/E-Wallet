class Rate {
  int id;

  // ignore: non_constant_identifier_names
  double rate_sell;

  // ignore: non_constant_identifier_names
  double rate_buy;
  String date;
  int currency;
  String currencyName;

  Rate(this.id, this.rate_sell, this.rate_buy, this.date, this.currency, this.currencyName);

  Rate.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        rate_sell = json['rate_sell'],
        rate_buy = json['rate_buy'],
        date = json['date'],
        currency = json['currency'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'rate_sell': rate_sell,
        'rate_buy': rate_buy,
        'date': date,
        'currency': currency,
      };
}
