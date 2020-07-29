
class Transaction {

  int id;
  double amount;
  int wallet;
  int currency;
  int rate;
  String currencyName;

  Transaction(this.id, this.amount, this.wallet, this.currency, this.rate, this.currencyName);

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        wallet = json['wallet'],
        currency = json['currency'],
        rate = json['rate'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'wallet': wallet,
    'currency': currency,
    'rate': rate
  };
}
