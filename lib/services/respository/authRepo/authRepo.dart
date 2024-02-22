abstract class AuthRepo{
  Future<String> authenticate({
    required String email,
    required String password,
  });
  Future<String> register({
    required String email,
    required String password
  });

}


class AuthRepoImplementation extends AuthRepo{
  @override
  Future<String> authenticate({required String email, required String password}) async{
      await Future.delayed(Duration(seconds: 1));
      return 'token';
  }

  @override
  Future<String> register({required String email, required String password}) async{
    await Future.delayed(Duration(seconds: 1));
    return 'token';
  }

}