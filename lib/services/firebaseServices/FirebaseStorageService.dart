
import 'dart:io';

import 'package:expense_calc/services/localData/AppData.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String mainDoc = 'ExpenseCalculator';
abstract class FBStorage {

  Reference ref = FirebaseStorage.instance.ref().child(mainDoc);

  Future<String> upload(String filePath) async{
    String fileName = 'IMG_${AppData.uid}';
    String fileExtension = filePath.getFileExtension;
    final uploadTask  = await ref.child('$fileName$fileExtension').putFile(File(filePath));
    TaskSnapshot snapshot = uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<bool> remove(String url) async{
    try{
      await ref.child(url).delete();
      return true;
    }catch(e){
      rethrow;
    }
  }
}

class FBStorageService extends FBStorage{

}





