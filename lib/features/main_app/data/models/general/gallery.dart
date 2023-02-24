
import 'package:lifestep/features/tools/config/endpoint_config.dart';
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
    image = json['image'] != null ? sprintf( EndpointConfig.imageUrl , [json['image']]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}