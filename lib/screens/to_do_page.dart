import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  List _tarefas = [];
  final TextEditingController _novaItemController = TextEditingController();
  final TextEditingController _editarTarefaController = TextEditingController();
  Map<String, dynamic> _ultimaTarefaRemovida = Map();
  var showSearchBar = false;

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.absolute}/tarefas.json");
  }

  _adicionarItem() {
    String textoDigitado = _novaItemController.text;
    Map<String, dynamic> item = Map();
    item["nome"] = textoDigitado;
    item["check"] = false;
    setState(() {
      _tarefas.add(item);
    });
    _salvarArquivo();
    _novaItemController.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();
    String dados = jsonEncode(_tarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then((dados) {
      setState(() {
        _tarefas = jsonDecode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (showSearchBar)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar',
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(
                    "key${_tarefas[index]}${DateTime.now().millisecondsSinceEpoch.toString()}",
                  ),
                  onDismissed: (direction) {
                    _ultimaTarefaRemovida = _tarefas[index];

                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        _tarefas.removeAt(index);
                      });

                      final snackBar = SnackBar(
                        duration: const Duration(seconds: 3),
                        content: const Text("Tarefa removida"),
                        action: SnackBarAction(
                          label: "Desfazer",
                          onPressed: () {
                            setState(() {
                              _tarefas.insert(index, _ultimaTarefaRemovida);
                            });
                            _salvarArquivo();
                          },
                        ),
                      );

                      _salvarArquivo();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (direction == DismissDirection.startToEnd) {
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (context) {
                            _editarTarefaController.text =
                            _tarefas[index]["nome"];
                            return AlertDialog(
                              title: const Text("Editar Tarefa"),
                              content: TextField(
                                decoration: const InputDecoration(
                                  labelText: "Digite o nome",
                                ),
                                onChanged: (text) {},
                                controller: _editarTarefaController,
                              ),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Cancelar"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ElevatedButton(
                                  child: const Text("Salvar"),
                                  onPressed: () {
                                    _tarefas[index]["nome"] =
                                        _editarTarefaController.text;
                                    setState(() {
                                      _salvarArquivo();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    }
                  },
                  background: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.green,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Editar",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.red,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Excluir",
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: CheckboxListTile(
                      tileColor: Colors.black26,
                      activeColor: Colors.deepOrange,
                      title: Text(
                        _tarefas[index]["nome"],
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      value: _tarefas[index]["check"],
                      onChanged: (update) {
                        setState(() {
                          _tarefas[index]["check"] = update;
                        });
                        _salvarArquivo();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _salvarArquivo();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Nova Tarefa"),
                content: TextField(
                  decoration: const InputDecoration(
                    labelText: "Digite seu Tarefa",
                  ),
                  onChanged: (text) {},
                  controller: _novaItemController,
                ),
                actions: [
                  ElevatedButton(
                    child: const Text("Cancelar"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    child: const Text("Adicionar"),
                    onPressed: () {
                      _adicionarItem();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}