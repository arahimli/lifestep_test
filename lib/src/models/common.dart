class ResponseData {
  List<DataModel>? data;

  ResponseData({this.data});

  ResponseData.fromJson(List<dynamic> json) {
      data = <DataModel>[];
      json.forEach((v) {
        data!.add(DataModel.fromJson(v));
      });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataModel {
  String? id;
  String? buyImage;
  String? winImage;
  String? prizeImage;
  String? tickets;
  String? quantity;
  String? timer;
  String? drawDate;
  String? price;
  String? deliveryPrice;
  String? coupon;
  String? homepage;
  String? sale;
  String? catalog;
  String? createdAt;
  String? updatedAt;
  Translation? translation;

  DataModel(
      {this.id,
        this.buyImage,
        this.winImage,
        this.prizeImage,
        this.tickets,
        this.quantity,
        this.timer,
        this.drawDate,
        this.price,
        this.deliveryPrice,
        this.coupon,
        this.homepage,
        this.sale,
        this.catalog,
        this.createdAt,
        this.updatedAt,
        this.translation});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyImage = json['buy_image'];
    winImage = json['win_image'];
    prizeImage = json['prize_image'];
    tickets = json['tickets'];
    quantity = json['quantity'];
    timer = json['timer'];
    drawDate = json['draw_date'];
    price = json['price'];
    deliveryPrice = json['delivery_price'];
    coupon = json['coupon'];
    homepage = json['homepage'];
    sale = json['sale'];
    catalog = json['catalog'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['buy_image'] = buyImage;
    data['win_image'] = winImage;
    data['prize_image'] = prizeImage;
    data['tickets'] = tickets;
    data['quantity'] = quantity;
    data['timer'] = timer;
    data['draw_date'] = drawDate;
    data['price'] = price;
    data['delivery_price'] = deliveryPrice;
    data['coupon'] = coupon;
    data['homepage'] = homepage;
    data['sale'] = sale;
    data['catalog'] = catalog;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (translation != null) {
      data['translation'] = translation!.toJson();
    }
    return data;
  }
}

class Translation {
  String? id;
  String? ownerId;
  String? language;
  String? buyTitle;
  String? buyBody;
  String? prizeBody;
  String? winTitle;
  String? winBody;

  Translation(
      {this.id,
        this.ownerId,
        this.language,
        this.buyTitle,
        this.buyBody,
        this.prizeBody,
        this.winTitle,
        this.winBody});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['owner_id'];
    language = json['language'];
    buyTitle = json['buy_title'];
    buyBody = json['buy_body'];
    prizeBody = json['prize_body'];
    winTitle = json['win_title'];
    winBody = json['win_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['owner_id'] = ownerId;
    data['language'] = language;
    data['buy_title'] = buyTitle;
    data['buy_body'] = buyBody;
    data['prize_body'] = prizeBody;
    data['win_title'] = winTitle;
    data['win_body'] = winBody;
    return data;
  }
}