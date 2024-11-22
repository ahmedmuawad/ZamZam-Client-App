class DistanceModel {
  late List<String?> destinationAddresses;
  late List<String?> originAddresses;
  late List<Rows> rows;
  String? status;

  DistanceModel(
      {required this.destinationAddresses,
      required this.originAddresses,
      required this.rows,
      this.status});

  DistanceModel.fromJson(Map<String?, dynamic> json) {
    destinationAddresses = json['destination_addresses'].cast<String?>();
    originAddresses = json['origin_addresses'].cast<String?>();
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows.add(new Rows.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['destination_addresses'] = this.destinationAddresses;
    data['origin_addresses'] = this.originAddresses;
    data['rows'] = this.rows.map((v) => v.toJson()).toList();
    data['status'] = this.status;
    return data;
  }
}

class Rows {
  late List<Elements> elements;

  Rows({required this.elements});

  Rows.fromJson(Map<String?, dynamic> json) {
    if (json['elements'] != null) {
      elements = [];
      json['elements'].forEach((v) {
        elements.add(new Elements.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['elements'] = this.elements.map((v) => v.toJson()).toList();
    return data;
  }
}

class Elements {
  Distance? distance;
  Distance? duration;
  String? status;

  Elements({this.distance, this.duration, this.status});

  Elements.fromJson(Map<String?, dynamic> json) {
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? new Distance.fromJson(json['duration'])
        : null;
    status = json['status'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['distance'] = this.distance?.toJson();
    data['duration'] = this.duration?.toJson();
    data['status'] = this.status;
    return data;
  }
}

class Distance {
  String? text;
  double? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String?, dynamic> json) {
    text = json['text'];
    value = json['value'].toDouble();
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}
