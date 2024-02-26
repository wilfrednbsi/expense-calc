import 'package:expense_calc/model/ProfileModel.dart';

import '../../firebaseServices/FirebaseStorageService.dart';
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

  Future<bool> updateProfile({required ProfileModel data});

  Future<String> uploadImage({required String imagePath});
  Future<bool> changePassword({required String oldPassword, required String newPassword});
}

class AuthRepoImplementation extends AuthRepo {
  final _userCollection = FirebaseDBService('user', 'user');
  final _storage = FBStorageService();

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
        final snap =
            await _userCollection.add({'email': email, 'password': password});
        return snap.id;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    await SharedPref.getUid();
    return AppData.uid != null;
  }

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final doc = await _userCollection.getDoc(AppData.uid!);
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return ProfileModel.fromJson(data);
      } else {
        throw 'Data not found';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateProfile({required ProfileModel data}) async {
    try {
      await _userCollection.updateDoc(AppData.uid!, data.toJsonUpdateDoc());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadImage({required String imagePath, String? oldUrl}) async {
    try{
      final url = await _storage.upload(imagePath);
      // if(oldUrl != null){
      //   await _storage.remove(oldUrl);
      // }
      return url;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<bool> changePassword({required String oldPassword, required String newPassword}) async{
    try{
      final data = await getProfile();
      if(oldPassword.isEquals(data.password ?? '')){
        await _userCollection.updateDoc(AppData.uid!, {'password':newPassword});
        return true;
      }else{
        throw 'Entered wrong password';
      }
    }catch(e){
      rethrow;
    }
  }
}
