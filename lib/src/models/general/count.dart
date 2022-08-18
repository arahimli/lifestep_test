
import 'package:flutter/cupertino.dart';
import 'package:lifestep/src/tools/packages/humanize/humanize_big_int_base.dart';

class CountModel{
  final int value;

  factory CountModel.getValue({int? val}) {
    return CountModel(val ?? 0);
  }

  CountModel(this.value);

}


extension CountModelExtension on CountModel {

  String humanizeInteger(BuildContext context, {int length : 6}) {
    try{
      if(value.toString().length > length)
        return humanizeInt(context, value).toLowerCase();
      else
        return value.toString();
    }catch(_){
      return '0';
    }
  }

}