abstract class TransactionRepo {
  Future<bool> addFund({required num amount});
  Future<bool> newTransaction({required num amount, required String desc});
  Future<bool> addToPlan({required num amount, required String planId});
}

class TransactionRepoImplementation extends TransactionRepo{
  @override
  Future<bool> addFund({required num amount}) async{
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }

  @override
  Future<bool> newTransaction({required num amount, required String desc}) async{
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }

  @override
  Future<bool> addToPlan({required num amount, required String planId}) async{
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }

}