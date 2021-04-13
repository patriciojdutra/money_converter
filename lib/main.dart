import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=d9963e56";

void main() async {
  runApp(MyApp());
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )),
      home: MyHomePage(title: '\$ Conversor \$'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final realControll = TextEditingController();
  final dolarControll = TextEditingController();
  final euroControll = TextEditingController();

  double dolar;
  double euro;

  void realChaged(String txt){
    double real = double.parse(txt);
    dolarControll.text = (real/dolar).toStringAsFixed(2);
    euroControll.text = (real/euro).toStringAsFixed(2);
  }

  void dolarChaged(String txt){
    double dolar = double.parse(txt);
    realControll.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControll.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void euroChaged(String txt){
    double euro = double.parse(txt);
    realControll.text = (euro * this.euro).toStringAsFixed(2);
    dolarControll.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados...",
                    style: TextStyle(color: Colors.amber),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro ao carregar dados :("),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                        edtText("R\$ ", "Reais", realControll, realChaged),
                        Divider(),
                        edtText("US\$ ", "Dolares", dolarControll, dolarChaged),
                        Divider(),
                        edtText("EU ", "Euros", euroControll, euroChaged),
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }
}

Widget edtText(String prefix, String text, TextEditingController controller, Function f) {
  return TextField(
    controller: controller,
    onChanged: f,
    decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
  );
}
