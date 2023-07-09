class ApiFactory {
  static String get domain => "http://api.openweathermap.org";
  static String get appID => "bcc387ae4d6fa2a2a2a45de0737ef334";
  static String getWeatherURL(
    String lat,
    String lon,
  ) =>
      "$domain/data/2.5/forecast?lat=$lat&lon=$lon&appid=$appID";
  static String getSearchCountryURL(String country) => "$domain/geo/1.0/direct?q=$country&limit=5&appid=$appID";
}
