class MapDistanceResponse {
  List<String>? destinationAddresses;
  List<String>? originAddresses;
  List<Rows>? rows;
  String? status;

  MapDistanceResponse(
      {this.destinationAddresses,
        this.originAddresses,
        this.rows,
        this.status});

  MapDistanceResponse.fromJson(Map<String, dynamic> json) {
    destinationAddresses = json['destination_addresses'].cast<String>();
    originAddresses = json['origin_addresses'].cast<String>();
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(Rows.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['destination_addresses'] = destinationAddresses;
    data['origin_addresses'] = originAddresses;
    if (rows != null) {
      data['rows'] = rows!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Rows {
  List<Elements>? elements;

  Rows({this.elements});

  Rows.fromJson(Map<String, dynamic> json) {
    if (json['elements'] != null) {
      elements = <Elements>[];
      json['elements'].forEach((v) {
        elements!.add(Elements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (elements != null) {
      data['elements'] = elements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Elements {
  Distance? distance;
  Distance? duration;
  Distance? durationInTraffic;
  String? status;

  Elements({this.distance, this.duration, this.durationInTraffic, this.status});

  Elements.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? Distance.fromJson(json['duration'])
        : null;
    durationInTraffic = json['duration_in_traffic'] != null
        ? Distance.fromJson(json['duration_in_traffic'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    if (durationInTraffic != null) {
      data['duration_in_traffic'] = durationInTraffic!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}
