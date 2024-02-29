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

class AddPlanEvent extends TransactionEvent {
  final String plan;
  final String target;
  final String amount;

  const AddPlanEvent({required this.plan, required this.target, required this.amount});

  @override
  List<Object?> get props => [plan,target,amount];
}

class AddAmountToPlanEvent extends TransactionEvent {
  final String amount;
  const AddAmountToPlanEvent({required this.amount});
  @override
  List<Object?> get props => [amount];
}

class RefreshEvent extends TransactionEvent {
  @override
  List<Object?> get props => [];
}

class ChoosePlanEvent extends TransactionEvent {
  final PlanModel plan;
  const ChoosePlanEvent({required this.plan});
  @override
  List<Object?> get props => [plan];
}

class SetTargetPlanEvent extends TransactionEvent {
  final String target;
  const SetTargetPlanEvent({required this.target});
  @override
  List<Object?> get props => [target];
}

