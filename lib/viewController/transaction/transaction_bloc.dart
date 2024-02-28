import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_calc/model/PlanModel.dart';
import 'package:expense_calc/model/SummaryModel.dart';
import 'package:expense_calc/model/TransactionModel.dart';
import 'package:expense_calc/services/localData/AppData.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/utils/DateTimeUtils.dart';
import 'package:flutter/material.dart';

import '../../components/constants/constants.dart';
import '../../services/respository/transation/transactionRepo.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final repo = TransactionRepoImplementation();

  num availableAmount = 0;
  num expenses = 0;
  num savings = 0;

  List<TransactionModel> tranList = [];
  List<PlanModel> planList = [];

  List<TransactionModel> get getLastTransactions {
    if (tranList.length > 10) {
      return tranList.sublist(0, 11);
    } else {
      return tranList;
    }
  }

  PlanModel choosePlan = PlanModel();

  void resetChoosePlan() {
    choosePlan = PlanModel();
  }

  String planNameAddPlan = '';
  num targetAddPlan = 0;
  num initialAddPlan = 0;

  void resetAddPlan() {
    planNameAddPlan = '';
    targetAddPlan = 0;
    initialAddPlan = 0;
  }

  TransactionBloc() : super(TransactionInitial()) {
    on<AddFundEvent>(_onAddFund);
    on<NewTransactionEvent>(_createTransaction);
    on<GetTransactionEvent>(_getData);
    on<AddPlanEvent>(_onAddPlan);
    on<AddAmountToPlanEvent>(_onAddAmountToPlan);
    on<ChoosePlanEvent>(_onChoosePlan);
    on<RefreshEvent>(_refresh);
    on<SetTargetPlanEvent>(_setTargetPlan);
  }

  FutureOr<void> _onAddFund(
      AddFundEvent event, Emitter<TransactionState> emit) async {
    try {
      emit(TransactionLoadingState());
      if (event.fund.isNum && event.fund.getNum > 0) {
        final amount = event.fund.getNum;
        final obj = TransactionModel(
            desc: 'Fund Added!',
            amount: amount,
            timeStamp: DateTimeUtils.getCurrentTimeStamp,
            type: TransactionType.fundAdd.name,
            uid: AppData.uid);
        final summary = SummaryModel(
            savings: savings,
            expenses: expenses,
            available: availableAmount + amount);
        await repo.addTransaction(data: obj, summary: summary).then((value) {
          availableAmount = summary.available ?? 0;
          tranList.insert(0, obj);
          emit(TransactionCloseBSheetState());
          emit(TransactionSuccessState());
        });
      } else {
        emit(const TransactionAddFundFormError(
            error: 'Please enter valid amount'));
      }
    } catch (e) {
      emit(TransactionFailureState(error: e.toString()));
    }
  }

  FutureOr<void> _createTransaction(
      NewTransactionEvent event, Emitter<TransactionState> emit) async {
    try {
      emit(NewTransactionLoadingState());
      if (event.amount.isNum &&
          event.amount.getNum > 0 &&
          event.amount.getNum <= availableAmount &&
          event.desc.trim().isNotEmpty) {
        final amount = event.amount.getNum;
        final obj = TransactionModel(
            desc: event.desc.trim(),
            amount: amount,
            timeStamp: DateTimeUtils.getCurrentTimeStamp,
            type: TransactionType.expenses.name,
            uid: AppData.uid);

        final summary = SummaryModel(
            savings: savings,
            expenses: expenses + amount,
            available: availableAmount - amount);

        await repo.addTransaction(data: obj, summary: summary).then((value) {
          expenses = summary.expenses ?? 0;
          availableAmount = summary.available ?? 0;
          tranList.insert(0, obj);
          emit(NewTransactionSuccessState());
        });
      } else {
        emit(TransactionCreateFormError(
            amount: event.amount.isNum && event.amount.getNum > 0
                ? (event.amount.getNum <= availableAmount
                    ? ''
                    : 'You exceed available limits')
                : 'Please enter valid transaction amount',
            shortDesc: event.desc.trim().isNotEmpty
                ? ''
                : 'Please enter short description'));
      }
    } catch (e) {
      emit(NewTransactionFailureState(error: e.toString()));
    }
  }

  FutureOr<void> _getData(
      GetTransactionEvent event, Emitter<TransactionState> emit) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      emit(TransactionLoadingState());
      await repo.getSummary().then((value) {
        availableAmount = value.available ?? 0;
        expenses = value.expenses ?? 0;
        savings = value.savings ?? 0;
      });
      await repo.getTransactions().then((value) {
        tranList.clear();
        tranList.addAll(value);
      });
      await repo.getPlans().then((value) {
        planList.clear();
        planList.addAll(value);
      });
      emit(TransactionSuccessState());
    } catch (e) {
      emit(TransactionFailureState(error: e.toString()));
    }
  }

  FutureOr<void> _onAddPlan(
      AddPlanEvent event, Emitter<TransactionState> emit) async {
    try {
      emit(NewPlanLoadingState());
      if (event.plan.isNotEmpty &&
          event.target.isNum &&
          event.target.getNum > 0 &&
          (event.amount.isNotEmpty && event.amount.isNum
              ? (event.amount.getNum <= event.target.getNum) &&
                  (event.amount.getNum <= availableAmount)
              : true)) {
        await repo.addNewPlan(data: PlanModel()).then((value) {
          emit(PlanSuccessState());
          emit(NewPlanBSheetCloseState());
        });
      } else {
        emit(NewPlanFormValidationState(
            plan: event.plan.isNotEmpty ? '' : 'Please enter name for plan',
            target: event.target.isNum && event.target.getNum > 0
                ? ''
                : 'Please enter valid target amount',
            initial: event.amount.isNotEmpty && event.amount.isNum
                ? event.amount.getNum > event.target.getNum
                    ? 'Entered amount exceeds target limit'
                    : event.amount.getNum > availableAmount
                        ? 'You exceed available limits'
                        : ''
                : ''));
      }
    } catch (e) {
      emit(PlanFailureState(error: e.toString()));
    }
  }

  FutureOr<void> _onAddAmountToPlan(
      AddAmountToPlanEvent event, Emitter<TransactionState> emit) async {
    try {
      emit(PlanAmountLoadingState());
      if (choosePlan.id != null &&
          event.amount.isNum &&
          event.amount.getNum > 0 &&
          event.amount.getNum <= availableAmount &&
          event.amount.getNum <=
              ((choosePlan.target ?? 0) - (choosePlan.collected ?? 0))) {
        final summary = SummaryModel(
            available: availableAmount - event.amount.getNum,
            expenses: expenses,
            savings: savings + event.amount.getNum);
        try {
          await repo
              .addAmountToPlan(data: PlanModel(), summary: summary)
              .then((value) {
            availableAmount = summary.available ?? 0;
            savings = summary.savings ?? 0;

            //TODO: update plan list item here...

            emit(PlanAmountSuccessState());
          });
        } catch (e, s) {
          print(s);
        }
      } else {
        emit(PlanAmountFormValidationState(
            plan: choosePlan.id != null ? '' : 'Please choose your plan',
            amount: event.amount.isNum && event.amount.getNum > 0
                ? event.amount.getNum > availableAmount
                    ? 'You exceed available limits'
                    : event.amount.getNum >
                            ((choosePlan.target ?? 0) -
                                (choosePlan.collected ?? 0))
                        ? 'Entered amount is greater than required plan.'
                        : ''
                : 'Please enter valid amount'));
      }
    } catch (e) {
      emit(PlanAmountFailureState(error: e.toString()));
    }
  }

  FutureOr<void> _onChoosePlan(
      ChoosePlanEvent event, Emitter<TransactionState> emit) {
    choosePlan = PlanModel.fromJson(planList[0].toJson());
    emit(PlanAmountChoosePlanState());
  }

  FutureOr<void> _refresh(RefreshEvent event, Emitter<TransactionState> emit) {
    _refreshCall(emit);
  }

  void _refreshCall(Emitter emit) {
    if (state is TransactionInitial) {
      emit(RefreshState());
    } else {
      emit(TransactionInitial());
    }
  }

  FutureOr<void> _setTargetPlan(
      SetTargetPlanEvent event, Emitter<TransactionState> emit) {
    if (event.target.isNum) {
      targetAddPlan = event.target.getNum;
    } else {
      targetAddPlan = 0;
    }
    _refreshCall(emit);
  }
}

// UI and state management for Plans Tab using Bloc, with added features: "Add new plan" and "Add amount to plan to achieve target"
