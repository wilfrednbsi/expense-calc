import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_calc/model/TransactionModel.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/utils/DateTimeUtils.dart';

import '../../components/constants/constants.dart';
import '../../services/respository/transation/transactionRepo.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final repo = TransactionRepoImplementation();

  num availableAmount = 1542487;
  num expenses = 8954748;
  num savings = 5784878;

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
  }

  FutureOr<void> _onAddFund(AddFundEvent event, Emitter<TransactionState> emit) async{
    try{
      emit(TransactionLoadingState());
      if(event.fund.isNum){
        final amount = event.fund.getNum;
        await repo.addFund(amount: amount).then((value){
          availableAmount += amount;
          tranList.insert(0,TransactionModel(
            desc: 'Fund Added!',
            amount: amount,
            timeStamp: DateTimeUtils.getCurrentTimeStamp,
            type: TransactionType.fundAdd.name,
          ));
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
      if(event.amount.isNum && event.amount.getNum <= availableAmount && event.desc.trim().isNotEmpty){
        final amount = event.amount.getNum;
        await repo.newTransaction(amount: amount,desc: event.desc.trim()).then((value){
          expenses += amount;
          availableAmount -= amount;
          tranList.insert(0,TransactionModel(
            desc: event.desc.trim(),
            amount: amount,
            timeStamp: DateTimeUtils.getCurrentTimeStamp,
            type: TransactionType.expenses.name,
          ));
          emit(NewTransactionSuccessState());
        });
      }else{
        emit( TransactionCreateFormError(
          amount: event.amount.isNum?( event.amount.getNum <= availableAmount ?  '' : 'You exceed available limits'): 'Please enter valid transaction amount',
          shortDesc: event.desc.trim().isNotEmpty? '':'Please enter short description'
        ));
      }
    }catch(e){
      emit(NewTransactionFailureState(error: e.toString()));
    }
  }
}
