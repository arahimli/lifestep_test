import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language {
  final String languageCode;
  final String countryCode;
  final String name;

  Language({required this.languageCode, required this.countryCode, required this.name});

  Locale toLocale() {
    Platform.localeName;
    return Locale(languageCode, countryCode);
  }
  Future<Locale> startLocale() async{

    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('language')) {
      if(Platform.localeName.contains('ru')){
        await pref.setString('language', 'ru');
        LANGUAGE = 'ru';
        return const Locale('ru', 'RU');
      // }else if(Platform.localeName.contains('en')){
      //   await pref.setString('language', 'en');
      //   LANGUAGE = 'en';
      //   return Locale('en', 'EN');
      }else{
        await pref.setString('language', 'az');
        LANGUAGE = 'az';
        return const Locale('az', "AZ");
      }
    }else {
      LANGUAGE = pref.getString('language')!;
      return Locale(pref.getString('language')!, pref.getString('language').toString().toUpperCase());
    }

  }
}