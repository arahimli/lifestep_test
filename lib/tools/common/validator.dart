

class FormValidator {

  validPhone(String value, {bool req=true}){
    if(value != null && value != ''){
      if(value.length != 9)return false;
      else return true;
    }else{
      if(req)return false;
      else return true;
    }
  }

  validEmail(String value, {bool req=false}){
    if(value != null && value != ''){
      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    }else{
      if(req)return false;
      else return true;
    }
  }

  validGender(String value, List<Map<String, dynamic>> dataMap, {bool req=true}){
    if(value != null && value != ''){
      List<Map<String, dynamic>> listResult = dataMap.where((map) => value == map["keyword"].toString()).toList();
      return listResult.length > 0;
    }else{
      if(req)return false;
      else return true;
    }
  }
  validFullName(String value, {bool req=true}){
    if(value != null && value != ''){

      var valChecked = value.trim().split(' ');
      if (valChecked.length >= 2) {
        return true;
      }
      else
        return false;
    }else{
      if(req)return false;
      else return true;
    }
  }
  validDate(String value, {bool req=true}){
    if(value != null && value != ''){
      return RegExp(r"^([0-2][0-9]|(3)[0-1])(\.)(((0)[0-9])|((1)[0-2]))(\.)\d{4}$").hasMatch(value);
    }else{
      if(req)return false;
      else return true;
    }
  }
  validHeight(String value, {bool req=true}){
    if(value != null && value != ''){
      try {
        return int.parse(value) > 0;
      }catch(e) {
        return false;
      }
    }else{
      if(req)return false;
      else return true;
    }
  }
  validWeight(String value, {bool req=true}){
    if(value != null && value != ''){
      try {
        return int.parse(value) > 0;
      }catch(e) {
        return false;
      }
    }else{
      if(req)return false;
      else return true;
    }
  }
  validAmount(String value, {bool req=true}){
    if(value != null && value != ''){
      try {
        return double.parse(value) > 0;
      }catch(e) {
        return false;
      }
    }else{
      if(req)return false;
      else return true;
    }
  }
  validGoalStep(String value, {bool req=true}){
    if(value != null && value != ''){
      try {
        return int.parse(value) > 0;
      }catch(e) {
        return false;
      }
    }else{
      if(req)return false;
      else return true;
    }
  }
  validInviteCode(String value, {bool req=false}){
    if(value != null && value != ''){
      if (value.length > 0) {
        return true;
      }
      else return false;
    }else{
      if(req)return false;
      else return true;
    }
  }

  bool validOtp(String value, int length, {bool req=true}){
    if(value.trim().length == length){
      return true;
    }else{
      return false;
    }
  }
}