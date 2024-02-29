import 'package:expense_calc/model/PlanModel.dart';
import 'package:expense_calc/model/SummaryModel.dart';
import 'package:expense_calc/model/TransactionModel.dart';
import 'package:expense_calc/services/firebaseServices/FirebaseDBService.dart';
import 'package:expense_calc/services/localData/AppData.dart';

abstract class TransactionRepo {
  Future<bool> addTransaction({required TransactionModel data, required SummaryModel summary});
  Future<List<TransactionModel>> getTransactions();
  Future<SummaryModel> getSummary();
  Future<List<PlanModel>> getPlans();

  Future<String> addNewPlan({required PlanModel data, SummaryModel? summary, TransactionModel? transData,});
  Future<bool> addAmountToPlan({required PlanModel data, required SummaryModel summary, required TransactionModel transData,});
}

class TransactionRepoImplementation extends TransactionRepo {
  final _transColl = FirebaseDBService('data', 'transaction');
  final _planColl = FirebaseDBService('data', 'plan');
  final _summaryColl = FirebaseDBService('data', 'summary');

  @override
  Future<bool> addTransaction({required TransactionModel data, required SummaryModel summary}) async {
    try {
      await _addTransaction(data: data);
      await _updateSummary(data: summary);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final snapShot = await _transColl.documentsWhere(
          compareField: 'uid', compareValue: AppData.uid);
      if (snapShot.size > 0) {
        List<TransactionModel> list = List<TransactionModel>.from(snapShot.docs
            .map((doc) =>
                TransactionModel.fromJson(doc.data() as Map<String, dynamic>)));
        list.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
        return list;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SummaryModel> getSummary() async{
    try {
      try {
        final doc = await _summaryColl.getDoc(AppData.uid!);
        if (doc.exists && doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          return SummaryModel.fromJson(data);
        } else {
          return SummaryModel();
        }
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> addNewPlan({required PlanModel data,SummaryModel? summary, TransactionModel? transData}) async{
    try{
      final result = await _planColl.add(data.toJson());
      if(summary != null){
        await _updateSummary(data: summary);
      }
      if(transData != null){
        await _addTransaction(data: transData);
      }
      return result.id;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<List<PlanModel>> getPlans() async{
    try{
      final result = await _planColl.documentsWhere(compareField: 'uid', compareValue: AppData.uid!);
      if(result.size > 0){
        List<PlanModel> list = List<PlanModel>.from(result.docs
            .map((doc) =>
            PlanModel.fromJson({...doc.data() as Map<String, dynamic>,'docId': doc.id})));
        list.sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
        return list;
      }else{
        return [];
      }
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<bool> addAmountToPlan({required PlanModel data, required SummaryModel summary, required TransactionModel transData,}) async{
    try{
      await _planColl.updateDoc(data.docId!, data.toJsonUpdateAmount());
      await _updateSummary(data: summary);
      await _addTransaction(data:transData);
      return true;
    }catch(e){
      rethrow;
    }
  }


  Future<String> _updateSummary({required SummaryModel data}) => _summaryColl.setDoc(AppData.uid!, data.toJson());
  Future<String> _addTransaction({required TransactionModel data}) => _transColl.setDoc('${data.timeStamp}', data.toJson());
}
