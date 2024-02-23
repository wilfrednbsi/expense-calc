
import 'package:expense_calc/model/ProfileModel.dart';

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

  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile();
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

  @override
  Future<ProfileModel> getProfile() async{
   await Future.delayed(const Duration(seconds: 3));
   return ProfileModel(
     email: 'email@gmail.com',
     image: '',
     phone: '123567899755',
     name: 'Name',
     uid: '1356'
   );
  }

  @override
  Future<ProfileModel> updateProfile() async{
    await Future.delayed(const Duration(seconds: 3));
    return ProfileModel(
        email: 'email@gmail.com',
        image: '',
        phone: '123567899755',
        name: 'Updated Name',
        uid: '1356'
    );
  }
}
