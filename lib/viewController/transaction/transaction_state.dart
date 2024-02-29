part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}
class RefreshState extends TransactionState {
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

class NewPlanLoadingState extends TransactionState {
  @override
  List<Object> get props => [];
}
class PlanSuccessState extends TransactionState {
  @override
  List<Object> get props => [];
}
class PlanFailureState extends TransactionState {
  final String error;

  const PlanFailureState({required this.error});
  @override
  List<Object> get props => [error];
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

class PlanAmountLoadingState extends TransactionState {
  @override
  List<Object> get props => [];
}

class PlanAmountSuccessState extends TransactionState {
  @override
  List<Object> get props => [];
}

class PlanAmountFailureState extends TransactionState {
  final String error;
  const PlanAmountFailureState({required this.error});
  @override
  List<Object> get props => [error];
}

class PlanAmountFormValidationState extends TransactionState {
  final String plan;
  final String amount;

  const PlanAmountFormValidationState({required this.plan, required this.amount});

  @override
  List<Object> get props => [plan, amount];
}

class PlanAmountChoosePlanState extends TransactionState {
  @override
  List<Object> get props => [];
}

class NewPlanFormValidationState extends TransactionState {
  final String plan;
  final String target;
  final String initial;

  const NewPlanFormValidationState({required this.plan, required this.target, required this.initial});
  @override
  List<Object> get props => [plan,target,initial];
}

class NewPlanBSheetCloseState extends TransactionState {
  @override
  List<Object> get props => [];
}
