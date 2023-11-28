import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> listaMoedas = <String>[
  'Real',
  'Dolar',
  'Euro',
  'Bitcoin',
  'Sheike',
  'Litecoin',
  'Ethereum',
  'Ripple'
];

class Converter extends StatefulWidget {
  const Converter({Key? key}) : super(key: key);

  @override
  State<Converter> createState() => ConverterState();
}

class ConverterState extends State<Converter> {
  String _moedaOrigem = listaMoedas.first;
  String _moedaDestino = listaMoedas.last;
  String _moedaAcesso1 = "";
  String _moedaAcesso2 = "";
  String conversao = "";

  TextEditingController _valorController = TextEditingController();

  Map moedas = {
    "Real": "BRL",
    "Dolar": "USD",
    "Euro": "EUR",
    "Bitcoin": "BTC",
    "Sheike": "ILS",
    "Litecoin": "LTC",
    "Ethereum": "ETH",
    "Ripple": "XRP"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Moedas'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(padding: const EdgeInsets.all(16.0), children: [
        Column(
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
                      _moedaAcesso1 ??= _moedaOrigem;
                      _moedaOrigem = newValue!;
                      _moedaAcesso1 = newValue;
                    });
                  },
                  items:
                  listaMoedas.map<DropdownMenuItem<String>>((String value) {
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
                      _moedaAcesso2 ??= _moedaDestino;
                      _moedaDestino = newValue!;
                      _moedaAcesso2 = newValue;
                    });
                  },
                  items:
                  listaMoedas.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor',
                hintText: 'Digite um valor',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: obterTaxasDeConversao,
              child: const Text('Obter Taxas'),
            ),
            Center(
              child: Text(conversao,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ]),
    );
  }

  void obterTaxasDeConversao() async {
    var url = Uri.parse(
        "https://economia.awesomeapi.com.br/last/${moedas[_moedaAcesso2]}-${moedas[_moedaAcesso1]}");
    http.Response response;
    response = await http.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);

    String _chamada = moedas[_moedaAcesso2] + moedas[_moedaAcesso1];

    double taxaDeCambio = double.parse(retorno[_chamada]["high"]);
    double valor = double.parse(_valorController.text);

    double valorConvertido = valor * taxaDeCambio;

    setState(() {
      conversao =
      "A conversão ${retorno[_chamada]["name"]} é de ${valor.toStringAsFixed(2)} ${moedas[_moedaAcesso1]} para ${valorConvertido.toStringAsFixed(2)} ${moedas[_moedaAcesso2]}";
    });
  }
}
