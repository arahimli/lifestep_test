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
        data!.add(new NotificationModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['header'] = this.header;
    data['content'] = this.content;
    data['send_date'] = this.sendDate;
    data['send_time'] = this.sendTime;
    return data;
  }
}
