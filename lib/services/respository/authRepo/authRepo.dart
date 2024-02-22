
import '../../localData/AppData.dart';
import '/utils/AppExtensions.dart';

import '../../firebaseServices/FirebaseDBService.dart';
import '../../localData/SharedPref.dart';

abstract class AuthRepo {
  Future<String> authenticate({
    required String email,
    required String password,
  });

  Future<bool> isAuthenticated();

  Future<String> register({required String email, required String password});
}

class AuthRepoImplementation extends AuthRepo {
  final _userCollection = FirebaseDBService('user', 'user');

  @override
  Future<String> authenticate(
      {required String email, required String password}) async {
    try {
      final checkDoc = await _userCollection.checkIfDocExist('email', email);
      if (checkDoc.size > 0) {
        final snap = checkDoc.docs[0];
        final data = snap.data() as Map<String, dynamic>;
        if (password.isEquals(data['password'])) {
          SharedPref.setUid(snap.id);
          return snap.id;
        } else {
          throw 'Failed to login! wrong credentials';
        }
      } else {
        throw 'Failed to login! wrong credentials';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> register(
      {required String email, required String password}) async {
    try {
      final checkDoc = await _userCollection.checkIfDocExist('email', email);
      if (checkDoc.size > 0) {
        throw 'This email address is already registered with us.';
      } else {
        final snap = await _userCollection.add({'email': email, 'password': password});
        return snap.id;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isAuthenticated() async{
      await SharedPref.getUid();
      return AppData.uid != null;
  }
}
