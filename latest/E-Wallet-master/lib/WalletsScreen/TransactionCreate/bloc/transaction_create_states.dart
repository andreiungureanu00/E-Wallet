abstract class TransactionCreateStates extends Object {
  const TransactionCreateStates();
}

class TransactionInit extends TransactionCreateStates {}
class TransactionCreated extends TransactionCreateStates {}
class TransactionReloaded extends TransactionCreateStates {}