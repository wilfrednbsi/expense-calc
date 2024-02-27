import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_calc/model/SummaryModel.dart';
import 'package:expense_calc/model/TransactionModel.dart';
import 'package:expense_calc/services/localData/AppData.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/utils/DateTimeUtils.dart';

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

  List<TransactionModel> get getLastTransactions{
    if(tranList.length > 10){
      return tranList.sublist(0,11);
    }else{
      return tranList;
    }
  }

  TransactionBloc() : super(TransactionInitial()) {
    on<AddFundEvent>(_onAddFund);
    on<NewTransactionEvent>(_createTransaction);
    on<GetTransactionEvent>(_getData);
  }


  FutureOr<void> _onAddFund(AddFundEvent event, Emitter<TransactionState> emit) async{
    try{
      emit(TransactionLoadingState());
      if(event.fund.isNum && event.fund.getNum > 0){
        final amount = event.fund.getNum;
        final obj = TransactionModel(
          desc: 'Fund Added!',
          amount: amount,
          timeStamp: DateTimeUtils.getCurrentTimeStamp,
          type: TransactionType.fundAdd.name,
          uid: AppData.uid
        );
        final summary = SummaryModel(
            savings: savings,
            expenses: expenses,
            available: availableAmount + amount
        );
        await repo.addTransaction(data: obj, summary: summary).then((value){
          availableAmount = summary.available ?? 0;
          tranList.insert(0,obj);
          emit(TransactionCloseBSheetState());
          emit(TransactionSuccessState());
        });
      }else{
        emit(const TransactionAddFundFormError(error: 'Please enter valid amount'));
      }
    }catch(e){
      emit(TransactionFailureState(error: e.toString()));
    }
  }

  FutureOr<void> _createTransaction(NewTransactionEvent event, Emitter<TransactionState> emit) async{
    try{
      emit(NewTransactionLoadingState());
      if(event.amount.isNum && event.amount.getNum > 0 && event.amount.getNum <= availableAmount && event.desc.trim().isNotEmpty){
        final amount = event.amount.getNum;
        final obj = TransactionModel(
          desc: event.desc.trim(),
          amount: amount,
          timeStamp: DateTimeUtils.getCurrentTimeStamp,
          type: TransactionType.expenses.name,
            uid: AppData.uid
        );

        final summary = SummaryModel(
          savings: savings,
          expenses: expenses + amount,
          available: availableAmount - amount
        );

        await repo.addTransaction(data: obj, summary: summary).then((value){
          expenses = summary.expenses ?? 0;
          availableAmount = summary.available ?? 0;
          tranList.insert(0,obj);
          emit(NewTransactionSuccessState());
        });
      }else{
        emit( TransactionCreateFormError(
          amount: event.amount.isNum && event.amount.getNum > 0?( event.amount.getNum <= availableAmount ?  '' : 'You exceed available limits'): 'Please enter valid transaction amount',
          shortDesc: event.desc.trim().isNotEmpty? '':'Please enter short description'
        ));
      }
    }catch(e){
      emit(NewTransactionFailureState(error: e.toString()));
    }
  }

  FutureOr<void> _getData(GetTransactionEvent event, Emitter<TransactionState> emit) async{
    try{
     emit(ChangeState());
     await Future.delayed(const Duration(milliseconds: 200));
      emit(TransactionLoadingState());
      await repo.getSummary().then((value) {
        availableAmount = value.available ?? 0;
        expenses = value.expenses ?? 0;
        savings = value.savings ?? 0;
      });
      await repo.getTransactions().then((value){
        tranList.clear();
        tranList.addAll(value);
      });
      emit(TransactionSuccessState());
    }catch(e){
      emit(TransactionFailureState(error: e.toString()));
    }
  }
}
