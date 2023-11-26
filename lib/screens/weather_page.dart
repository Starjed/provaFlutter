import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _cityTextController = TextEditingController();
  final _dataService = WeatherService();

  WeatherResponse? _response;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
          backgroundColor: Colors.lightBlueAccent
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: _cityTextController,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                ),
              ),
            ),
            if (_response != null)
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _response!.nomeCidade,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Image.network(_response!.iconUrl),
                  Text(
                    '${_response!.tempInfo.temperatura}°',
                    style: const TextStyle(fontSize: 40),
                  ),
                  Text(_response!.climaInfo.description),
                ],
              )
            else
              const Text('Faça uma pesquisa para obter o clima.'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _search,
          tooltip: 'Pesquisar',
          child: const Icon(Icons.search),
        ),
    );
  }


  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    setState(() => _response = response);
  }
}
