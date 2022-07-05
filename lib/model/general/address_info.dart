class AddressInfoResponseData {
  PlusCode? plusCode;
  List<Results>? results;
  String? status;

  AddressInfoResponseData({this.plusCode, this.results, this.status});

  AddressInfoResponseData.fromJson(Map<String, dynamic> json) {
    plusCode = json['plus_code'] != null
        ? PlusCode.fromJson(json['plus_code'])
        : null;

    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode!.toJson();
    }
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }
}

class Results {
  List<AddressComponents>? addressComponents;
  String? formattedAddress;
  GeometryModel? geometry;
  String? placeId;
  PlusCode? plusCode;
  List<String>? types;

  Results(
      {this.addressComponents,
        this.formattedAddress,
        this.geometry,
        this.placeId,
        this.plusCode,
        this.types});

  Results.fromJson(Map<String, dynamic> json) {
    if (json['address_components'] != null) {
      addressComponents = <AddressComponents>[];
      json['address_components'].forEach((v) {
        addressComponents!.add( AddressComponents.fromJson(v));
      });
    }
    formattedAddress = json['formatted_address'];
    geometry = json['geometry'] != null
        ? GeometryModel.fromJson(json['geometry'])
        : null;
    placeId = json['place_id'];
    plusCode = json['plus_code'] != null
        ? PlusCode.fromJson(json['plus_code'])
        : null;
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.addressComponents != null) {
      data['address_components'] =
          this.addressComponents!.map((v) => v.toJson()).toList();
    }
    data['formatted_address'] = this.formattedAddress;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['place_id'] = this.placeId;
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode!.toJson();
    }
    data['types'] = this.types;
    return data;
  }
}

class AddressComponents {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponents({this.longName, this.shortName, this.types});

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longName = json['long_name'];
    shortName = json['short_name'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['long_name'] = this.longName;
    data['short_name'] = this.shortName;
    data['types'] = this.types;
    return data;
  }
}

class GeometryModel {
  LocationModel? location;
  String? locationType;
  Viewport? viewport;
  Viewport? bounds;

  GeometryModel({this.location, this.locationType, this.viewport, this.bounds});

  GeometryModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? LocationModel.fromJson(json['location'])
        : null;
    locationType = json['location_type'];
    viewport = json['viewport'] != null
        ? Viewport.fromJson(json['viewport'])
        : null;
    bounds =
    json['bounds'] != null ? Viewport.fromJson(json['bounds']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['location_type'] = this.locationType;
    if (this.viewport != null) {
      data['viewport'] = this.viewport!.toJson();
    }
    if (this.bounds != null) {
      data['bounds'] = this.bounds!.toJson();
    }
    return data;
  }
}

class LocationModel {
  double? lat;
  double? lng;

  LocationModel({this.lat, this.lng});

  LocationModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewport {
  LocationModel? northeast;
  LocationModel? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ? LocationModel.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? LocationModel.fromJson(json['southwest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.northeast != null) {
      data['northeast'] = this.northeast!.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest!.toJson();
    }
    return data;
  }
}