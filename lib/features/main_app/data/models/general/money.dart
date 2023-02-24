
import 'package:flutter/cupertino.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/packages/humanize/humanize_big_int_base.dart';

class MoneyModel{
  final double value;

  factory MoneyModel.getValue({double? val}) {
    return MoneyModel(val ?? 0);
  }

  MoneyModel(this.value);

}


extension MoneyModelExtension on MoneyModel {

  String humanizeDouble(BuildContext context, int length) {
    try{
      double newValue = Utils.roundNumber(value);
      if(newValue.toString().length > length){
        return "${humanizeInt(context, value.round()).toLowerCase()}${newValue.toString().split('.')[0].length < length-1 ? "."+newValue.toString().split('.')[1] : ''}";
      }else{
        return newValue.toString();
      }
    }catch(_){
      return '0';
    }
  }

}