part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class AddFundEvent extends TransactionEvent {
  final String fund;

  const AddFundEvent({required this.fund});

  @override
  List<Object?> get props => [fund];
}


class NewTransactionEvent extends TransactionEvent {
  final String amount;
  final String desc;

  const NewTransactionEvent({required this.amount, required this.desc});

  @override
  List<Object?> get props => [amount,desc];
}


class GetTransactionEvent extends TransactionEvent {
  @override
  List<Object?> get props => [];
}

