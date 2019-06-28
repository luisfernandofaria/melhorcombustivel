import 'package:flutter/material.dart';
import 'package:melhor_combustivel/model/posto.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

class PostoPage extends StatefulWidget {

  final Posto posto;

  PostoPage({this.posto});

  _PostoPageState createState() => _PostoPageState();
}

class _PostoPageState extends State<PostoPage> {
  final _nomeController = TextEditingController();
  final _valorAlcoolController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final _valorGasolinaController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final _resultadoController = TextEditingController();
  final _dataController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _postoEdited = false;
  Posto _postoTemp;

  Widget buildAppBar() {
    return AppBar(
      title: Text("Cadastrar Posto"),
      backgroundColor: Colors.blue,
      centerTitle: true,
    );
  }

  Widget buildFloatingActionSaveButton() {
    return FloatingActionButton(
      child: Icon(Icons.save),
      backgroundColor: Colors.blue,
      onPressed: () {
        if (_postoTemp.nome != null && _postoTemp.nome.isNotEmpty) {
          Navigator.pop(context, _postoTemp);
        } else {
          FocusScope.of(context).requestFocus(_nomeFocus);
        }
      },
    );
  }

  Future<bool> _requestPop() {
    if (_postoEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se continuar as alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                    child: Text("Descartar"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Widget buildScaffold() {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: buildAppBar(),
          floatingActionButton: buildFloatingActionSaveButton(),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Nome",
                  ),
                  onChanged: (text) {
                    _postoEdited = true;
                    setState(() {
                      _postoTemp.nome = text;
                    });
                  },
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: "Álcool", prefixText: "R\$ "),
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (text) {
                    _postoEdited = true;
                    setState(() {
                      _postoTemp.valorAlcool = text;
                    });
                  },
                  controller: _valorAlcoolController,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Gasolina", prefixText: "R\$ "),
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (text) {
                    _postoEdited = true;
                    setState(() {
                      _postoTemp.valorGasolina = text;
                    });
                  },
                  controller: _valorGasolinaController,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: escolherCombustivel,
                      child: Text(" Comparar "),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    RaisedButton(
                      onPressed: limparCampos,
                      child: Text(" Limpar "),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Text(_resultadoController.text),
                Text(_dataController.text),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold();
  }

  @override
  void initState() {
    super.initState();
    registrarData();
    if (widget.posto == null) {
      _postoTemp = Posto(data: _dataController.text);
    } else {
      _postoTemp = Posto.fromMap(widget.posto.toMap());

      _nomeController.text = _postoTemp.nome;
      _valorAlcoolController.text = _postoTemp.valorAlcool;
      _valorGasolinaController.text = _postoTemp.valorGasolina;
      _resultadoController.text = _postoTemp.resultado;

      _postoTemp.data = _dataController.text;
    }
  }

  void registrarData() {
    DateTime data = DateTime.now();
    setState(() {
      _dataController.text = DateFormat("dd/MM/yyyy - hh:mm:ss").format(data);
    });
  }

  void limparCampos() {
    _nomeController.text = '';
    _valorAlcoolController.text = '';
    _valorGasolinaController.text = '';
  }

  void escolherCombustivel() {
    double alcool = double.parse(_valorAlcoolController.text);
    double gasolina = double.parse(_valorGasolinaController.text);

    if (alcool / gasolina < 0.7) {
      _resultadoController.text = 'Álcool';
    } else {
      _resultadoController.text = 'Gasolina';
    }
    setState(() {
      _postoTemp.resultado = _resultadoController.text;
    });

    showDialog(context: context,

    builder: (context){
      return AlertDialog(

        title: Text(_resultadoController.text,
        textAlign: TextAlign.center),
        actions: <Widget>[
          FlatButton(
            child: Text("Voltar"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }
}
