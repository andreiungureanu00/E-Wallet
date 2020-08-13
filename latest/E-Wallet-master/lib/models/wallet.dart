class Wallet {
  int id;
  int user;
  int currency;
  var balance;

  // ignore: non_constant_identifier_names
  double value_buy;
  // ignore: non_constant_identifier_names
  double value_sell;
  double profit;
  String currencyName;

  Wallet(this.id, this.user, this.currency, this.balance, this.value_buy,
      this.value_sell, this.profit, this.currencyName);

  Wallet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = json['user'],
        currency = json['currency'],
        balance = json['balance'],
        value_buy = json['value_buy'],
        value_sell = json['value_sell'],
        profit = json['profit'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'currency': currency,
        'balance': balance,
        'value_buy': value_buy,
        'value_sell': value_sell,
        'profit': profit,
      };

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['user'] = user;
    map['currency'] = currency;
    map['balance'] = balance;
    map['value_buy'] = value_buy;
    map['value_sell'] = value_sell;
    map['profit'] = profit;

    return map;
  }
}
