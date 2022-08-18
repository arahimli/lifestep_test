
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:sprintf/sprintf.dart';

class GalleryModel {
  int? id;
  String? image;

  GalleryModel(
      {
        this.id,
        this.image,
      });

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? sprintf( IMAGE_URL , [json['image']]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}