import 'package:expense_calc/model/SummaryModel.dart';
import 'package:expense_calc/model/TransactionModel.dart';
import 'package:expense_calc/services/firebaseServices/FirebaseDBService.dart';
import 'package:expense_calc/services/localData/AppData.dart';

abstract class TransactionRepo {
  Future<bool> addTransaction({required TransactionModel data, required SummaryModel summary});

  Future<List<TransactionModel>> getTransactions();
  Future<SummaryModel> getSummary();
}

class TransactionRepoImplementation extends TransactionRepo {
  final _transColl = FirebaseDBService('data', 'transaction');
  final _summaryColl = FirebaseDBService('data', 'summary');

  @override
  Future<bool> addTransaction({required TransactionModel data, required SummaryModel summary}) async {
    try {
      await _transColl.setDoc('${data.timeStamp}', data.toJson());
      await _summaryColl.setDoc(AppData.uid!, summary.toJson());
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
}
