class SearchCountryStateModel {
  String? name;
  Map<String, dynamic>? localNames;
  double? lat;
  double? lon;
  String? country;
  String? state;

  SearchCountryStateModel({this.name, this.localNames, this.lat, this.lon, this.country, this.state});

  SearchCountryStateModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    localNames = json['local_names'];
    lat = json['lat'];
    lon = json['lon'];
    country = json['country'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['lat'] = lat;
    data['lon'] = lon;
    data['country'] = country;
    data['state'] = state;
    return data;
  }
}
