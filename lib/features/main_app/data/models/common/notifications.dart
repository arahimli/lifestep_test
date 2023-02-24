class NotificationListResponse {
  bool? status;
  List<NotificationModel>? data;
  String? message;

  NotificationListResponse({this.status, this.data, this.message});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <NotificationModel>[];
      json['data'].forEach((v) {
        data!.add(NotificationModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}


class NotificationModel {
  int? id;
  String? header;
  String? content;
  String? sendDate;
  String? sendTime;

  NotificationModel({this.id, this.header, this.content, this.sendDate, this.sendTime});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    content = json['content'];
    sendDate = json['send_date'];
    sendTime = json['send_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['header'] = header;
    data['content'] = content;
    data['send_date'] = sendDate;
    data['send_time'] = sendTime;
    return data;
  }
}
