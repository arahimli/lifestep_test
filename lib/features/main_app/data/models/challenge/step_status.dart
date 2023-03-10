import 'package:lifestep/features/tools/common/utlis.dart';

class StepStatusResponse {
  bool? status;
  StepStatusModel? data;
  String? message;

  StepStatusResponse({this.status, this.data, this.message});

  StepStatusResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? StepStatusModel.fromJson(json['data']) : null;
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

class StepStatusModel {
  int? id;
  int? userId;
  int? step;
  DateTime? datetime;
  DateTime? currentdate;

  StepStatusModel({this.id, this.userId, this.step, this.datetime, this.currentdate});

  StepStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    step = json['step'];
    datetime = Utils.stringToDate(value: json['datetime'], format: "dd-MM-yyyy hh:mm");
    currentdate = Utils.stringToDate(value: json['currentdate'], format: "dd-MM-yyyy hh:mm");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['step'] = step;
    data['datetime'] = datetime;
    data['currentdate'] = currentdate;
    return data;
  }
}
