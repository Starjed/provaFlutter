import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Converter extends StatefulWidget {
  const Converter({Key? key}) : super(key: key);

  @override
  State<Converter> createState() => ConverterState();
}

class ConverterState extends State<Converter> {
  String _moedaOrigem = 'BRL'; // Moeda de origem padrão
  String _moedaDestino = 'USD'; // Moeda de destino padrão
  double _cotacao = 0.0;
  bool _exibirCotacao = false;

  List<String> _moedas = ['BRL', 'USD', 'EUR', 'ILS', 'BTC', 'LTC', 'ETH', 'XRP'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Moedas'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _moedaOrigem,
                  onChanged: (String? newValue) {
                    setState(() {
                      _moedaOrigem = newValue!;
                      _moedas.remove(_moedaOrigem);
                    });
                  },
                  items: _moedas.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16.0),
                DropdownButton<String>(
                  value: _moedaDestino,
                  onChanged: (String? newValue) {
                    setState(() {
                      _moedaDestino = newValue!;
                    });
                  },
                  items: _moedas.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _obterCotacao();
                setState(() {
                  _exibirCotacao = true;
                });
              },
              child: const Text('Obter Cotação'),
            ),
            const SizedBox(height: 16.0),
            if (_exibirCotacao)
              Text('Cotação: $_cotacao $_moedaDestino por $_moedaOrigem'),
          ],
        ),
      ),
    );
  }

  void _obterCotacao() async {
    try {
      Map<String, dynamic> taxas = await obterTaxasDeConversao(_moedaOrigem, _moedaDestino);

      Map<String, dynamic> moedaDestino = taxas[_moedaOrigem + _moedaDestino];

      if (moedaDestino != null) {
        _cotacao = double.parse(moedaDestino['high']);
      } else {
        _cotacao = 0.0;
      }
      setState(() {});
    } catch (e) {
      print('Erro durante a chamada da API: $e');
    }
  }

  Future<Map<String, dynamic>> obterTaxasDeConversao(String firstMoeda, String lastMoeda) async {
    try {
      var url = Uri.parse("https://economia.awesomeapi.com.br/last/$firstMoeda-$lastMoeda");
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> retorno = json.decode(response.body);

        if (retorno.containsKey('data')) {
          retorno = retorno['data'];
        }
        return retorno;
      } else {
        throw Exception('Erro na resposta da API. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a chamada da API: $e');
      throw Exception('Erro ao obter taxas de conversão');
    }
  }
}
