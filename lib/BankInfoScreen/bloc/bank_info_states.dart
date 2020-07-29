abstract class BankInfoStates extends Object {
  const BankInfoStates();
}

class BankInfoInit extends BankInfoStates {}
class BankInfoLoaded extends BankInfoStates {}
class BankInfoReloaded extends BankInfoStates {}