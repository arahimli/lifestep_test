
class LoginResponse {
  bool? status;
  // Data? data;
  String? message;

  LoginResponse({this.status, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    // data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['status'] = status;
    // if (this.data != null) {
    //   data['data'] = this.data!.toJson();
    // }
    data['message'] = message;
    return data;
  }
}


// class Data {
//   UserModel? user;
//   String? otp;
//   String? token;
//
//   Data({this.user, this.otp, this.token});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
//     token = json['token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic>  data = <String,dynamic>{};
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     data['otp'] = this.otp;
//     data['token'] = this.token;
//     return data;
//   }
// }
