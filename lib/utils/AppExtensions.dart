import 'package:expense_calc/components/constants/constants.dart';
import 'package:expense_calc/components/widgets/dialog/FailureMessageDialog.dart';
import 'package:flutter/material.dart';

import '../components/coreComponents/AppDialog.dart';
import '../components/coreComponents/AppLoader.dart';

extension NavigatorExtn on BuildContext{
  // navigate to next screen
  void  pushNavigator(Widget screen) => Navigator.push(this, MaterialPageRoute(builder: (context) => screen,));

  // push and replace ......
  void  replaceNavigator(Widget screen) => Navigator.pushReplacement(this, MaterialPageRoute(builder: (context) => screen,));

  // clear stack and navigate to screen....
  void  pushAndClearNavigator(Widget screen) =>
      Navigator.pushAndRemoveUntil(this, MaterialPageRoute(builder: (context) => screen,), (route) => false);

  //pop back...
  void  pop() => Navigator.pop(this);

  // // show progress loader....
  // void get load => appLoader(this);
  //
  // // close progressLoader or dialog .....
  // void get  stopLoader => Navigator.of(this,rootNavigator: false).pop('dialog');
  //
  // // show popup dialog ....
  // void openDialog(Widget child) => appDialog(this, child);
  //
  // // check whether is portrait mode state ...
  // bool get isPortraitMode => MediaQuery.of(this).orientation == Orientation.portrait;
}


extension AppStateExtn on BuildContext{
// show progress loader....
  void get load => appLoader(this);

// close progressLoader or dialog .....
  void get stopLoader => Navigator.of(this, rootNavigator: false).pop('dialog');

// show popup dialog ....
  void openDialog(Widget child) => appDialog(this, child);

  // show popup dialog ....
  void openFailureDialog(String message) => appDialog(this, FailureMessageDailog(
      message: message,
    onTap: (){
      stopLoader;
    } ,
    dismiss: (){
      stopLoader;
    },
  ));

// check whether is portrait mode state ...
  bool get isPortraitMode =>
      MediaQuery.of(this).orientation == Orientation.portrait;
}



extension StringExtn on String{
  // password condition check....
  bool get isPassword => length > 6 && length< 25;

  bool isEquals(String value) => compareTo(value) == 0;
  bool get isPhone => true;

  bool get isEmail => _hasMatch(this,
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  String get getFileName {
    int lastIndex = lastIndexOf('/');
    if (lastIndex != -1 && lastIndex < length - 1) {
      return substring(lastIndex + 1);
    }
    return this;
  }

  String get getFileExtension {
    int lastIndex = lastIndexOf('.');
    if (lastIndex != -1 && lastIndex < length - 1) {
      return substring(lastIndex);
    }
    return '';
  }
}



bool _hasMatch(String? value, String pattern) {
return (value == null) ? false : RegExp(pattern).hasMatch(value);
}



extension TransactionEnumExten on TransactionType{
  String get getName {
    String value = '';
    if(this == TransactionType.fundAdd){
      value = 'Fund Added!';
    }else if(this == TransactionType.rent){
      value = 'Rent';
    }
    return value;
  }
}