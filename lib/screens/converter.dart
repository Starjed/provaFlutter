import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> list = <String>['Real', 'Dolar', 'Euro', 'Bitcoin'];

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterState();
}

class _ConverterState extends State<ConverterPage> {
  String dropdownValue = list.first;
  String dropdownValue2 = list.first;
  String _chaveParaAcesso = "";
  String _chaveParaAcesso2 = "";
  double _sbh = 30.0;

  Map valores = {"Real":"BRL","Dolar":"USD","Euro":"EUR","Bitcoin":"BTC"};
  String _preco = "";

  void Converter() async{
    var url = Uri.parse(
        "https://economia.awesomeapi.com.br/last/${valores[_chaveParaAcesso2]}-${valores[_chaveParaAcesso]}");
    http.Response response;
    response = await http.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);
    print(retorno);
    String _chamada = valores[_chaveParaAcesso2]+valores[_chaveParaAcesso];
    //print(retorno);

    setState(() {
      _preco = "A conversão ${retorno[_chamada]["name"]} é de ${retorno[_chamada]["high"]}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Money API"),),
      body: ListView(children: [Container(child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_preco,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: _sbh,),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  _chaveParaAcesso = value;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: _sbh,),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue2,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue2 = value!;
                  _chaveParaAcesso2 = value;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: _sbh,),
            ElevatedButton(onPressed: Converter,
                child: Text("Converter"))
          ],),
      ),)],),
    );
  }
}
