import 'package:flutter/material.dart';
import 'package:melhor_combustivel/model/posto.dart';
import 'postoPage.dart';
import 'package:melhor_combustivel/helpers/posto_helper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  PostoHelper helper = PostoHelper();
  List <Posto> _listaDePostos = List();

  void _showPostoPage({Posto posto}) async {
    final regPosto = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostoPage(posto: posto)),
    );

    if (regPosto != null) {
      if (posto != null) {
        await helper.update(regPosto);
      } else {
        await helper.insert(regPosto);
      }
      _loadAllPostos();
    }
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text("Postos Cadastrados"),
      backgroundColor: Colors.blue,
      centerTitle: true,
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: () {
        _showPostoPage();
      },
    );
  }

  Widget buildCardPosto(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/posto.jpg")),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _listaDePostos[index].nome ?? " - ",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _listaDePostos[index].data ?? " - ",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _listaDePostos[index].resultado ?? " - ",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showPostoPage(posto: _listaDePostos[index]);},
    );
  }

  Widget buildListView() {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _listaDePostos.length,
        itemBuilder: (context, index) {
          return buildCardPosto(context, index);
        });
  }

  Widget buildScaffold() {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      floatingActionButton: buildFloatingActionButton(),
      body: buildListView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold();
  }

  void _loadAllPostos() {
    helper.selectAll().then((list) {
      setState(() {
        _listaDePostos = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAllPostos();
  }
}
