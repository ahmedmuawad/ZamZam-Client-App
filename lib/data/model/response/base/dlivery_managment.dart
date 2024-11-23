class Dliv {
  int? _status;
  double? _minShippingCharge;
  double? _shippingPerKm;

  Dliv(
      {int? status, double? minShippingCharge, double? shippingPerKm}) {
    this._status = status;
    this._minShippingCharge = minShippingCharge;
    this._shippingPerKm = shippingPerKm;
  }

  int? get status => _status;
  double? get minShippingCharge => _minShippingCharge;
  double? get shippingPerKm => _shippingPerKm;

  Dliv.fromJson(Map<String?, dynamic> json) {
    _status = json['status'];
    _minShippingCharge = json['min_shipping_charge'].toDouble();
    _shippingPerKm = json['shipping_per_km'].toDouble();
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['status'] = this._status;
    data['min_shipping_charge'] = this._minShippingCharge;
    data['shipping_per_km'] = this._shippingPerKm;
    return data;
  }
}
