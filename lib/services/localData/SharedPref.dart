
import 'package:expense_calc/components/constants/AppStrings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppData.dart';

const String _uidKey = 'uidKey${AppStrings.appName}';
class SharedPref{

    static late SharedPreferences _pref;

    static config() async{
      _pref = await SharedPreferences.getInstance();
      return;
    }

   static void setUid(String id){
     AppData.uid = id;
     _pref.setString(_uidKey, id);
   }

   static Future<String?> getUid() async{
    final id  = await _pref.getString(_uidKey);
    AppData.uid = id;

    return id;
   }

   static void clearUid(){
      _pref.remove(_uidKey);
      AppData.uid = null;
   }


   static void logout(){
      clearUid();
   }
}