class ClimaInfo {
  final String description;
  final String icon;

  ClimaInfo({required this.description, required this.icon});

  factory ClimaInfo.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    return ClimaInfo(description: description, icon: icon);
  }
}

class TemperaturaInfo {
  final double temperatura;

  TemperaturaInfo({required this.temperatura});

  factory TemperaturaInfo.fromJson(Map<String, dynamic> json) {
    final temperatura = json['temp'];
    return TemperaturaInfo(temperatura: temperatura);
  }
}

class WeatherResponse {
  final String nomeCidade;
  final TemperaturaInfo tempInfo;
  final ClimaInfo climaInfo;

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/${climaInfo.icon}@2x.png';
  }

  WeatherResponse({required this.nomeCidade, required this.tempInfo, required this.climaInfo});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final nomeCidade = json['name'];

    final tempInfoJson = json['main'];
    final tempInfo = TemperaturaInfo.fromJson(tempInfoJson);

    final climaInfoJson = json['weather'][0];
    final climaInfo = ClimaInfo.fromJson(climaInfoJson);

    return WeatherResponse(
        nomeCidade: nomeCidade, tempInfo: tempInfo, climaInfo: climaInfo);
  }
}