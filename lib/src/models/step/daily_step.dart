import 'package:lifestep/src/tools/common/utlis.dart';

class DailyStepStatusResponse {
  bool? status;
  DailyStepStatusModel? data;
  String? message;

  DailyStepStatusResponse({this.status, this.data, this.message});

  DailyStepStatusResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? DailyStepStatusModel.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class DailyStepStatusModel {
  int? id;
  int? userId;
  int? step;
  DateTime? datetime;
  DateTime? currentdate;

  DailyStepStatusModel({this.id, this.userId, this.step, this.datetime, this.currentdate});

  DailyStepStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    step = json['step'];
    datetime = Utils.stringToDate(value: json['date'], format: "dd-MM-yyyy");
    currentdate = Utils.stringToDate(value: json['currentdate'], format: "dd-MM-yyyy");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['step'] = step;
    data['date'] = datetime;
    data['currentdate'] = currentdate;
    return data;
  }
}
