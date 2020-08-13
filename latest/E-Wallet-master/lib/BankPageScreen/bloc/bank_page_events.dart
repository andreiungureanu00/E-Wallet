
abstract class BankPageEvents extends Object {
  const BankPageEvents();
}

class LoadBankPage extends BankPageEvents {}
class ReloadBankPage extends BankPageEvents {}
class LoadBankInfo extends BankPageEvents {}
class ReloadBankInfo extends BankPageEvents {}