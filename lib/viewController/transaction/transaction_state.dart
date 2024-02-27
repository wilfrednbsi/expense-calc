part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoadingState extends TransactionState {
  @override
  List<Object> get props => [];
}

class NewTransactionLoadingState extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionSuccessState extends TransactionState {
  @override
  List<Object> get props => [];
}

class NewTransactionSuccessState extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAddFundFormError extends TransactionState {
  final String error;

  const TransactionAddFundFormError({required this.error});
  @override
  List<Object> get props => [error];
}

class TransactionCreateFormError extends TransactionState {
  final String amount;
  final String shortDesc;
  const TransactionCreateFormError({required this.amount, required this.shortDesc});

  @override
  List<Object> get props => [amount,shortDesc];
}

class TransactionCloseBSheetState extends TransactionState {
  @override
  List<Object> get props => [];
}

class NewTransactionFailureState extends TransactionState {
  final String error;

  const NewTransactionFailureState({required this.error});
  @override
  List<Object> get props => [error];
}

class TransactionFailureState extends TransactionState {
  final String error;

  const TransactionFailureState({required this.error});
  @override
  List<Object> get props => [error];
}
