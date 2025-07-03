import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LangauageChnageController with ChangeNotifier{
  Locale? _locale;
  Locale? get locale=>_locale; 
  void chnagelanguage(Locale type)async{
    SharedPreferences sp =  await SharedPreferences.getInstance();
    _locale = type;
  if(type==Locale('en')){
    
   await sp.setString('languageCode', 'en');
  }
  else{
    sp.setString('languageCode', 'ur');
  }
  notifyListeners();
  }
}