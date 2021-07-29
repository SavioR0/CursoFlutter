import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
const url="https://api.hgbrasil.com/finance?format=json-cors&key=e4cce6c0";



void main() async{
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home : new Home(),
  ));
}

Future<Map> getData() async{
  http.Response reponse=await http.get(url);
  return json.decode(reponse.body);
}

class Home extends StatefulWidget{
  @override
  _HomeState createState()=>_HomeState();
}

class _HomeState extends State<Home>{
  double dolar;
  double euro;
  double real;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();


  void _limparTudo(){
     dolarController.text='';
      realController.text='';
      euroController.text='';
  }

  void _mudarReal(String text){
    if(text.isEmpty){
      _limparTudo();
      return;
    }
      double real= double.parse(text);
      dolarController.text= (real/dolar).toStringAsFixed(2);
      euroController.text=(real/euro).toStringAsFixed(2);

  }
  void _mudarDolar(String text){
    if(text.isEmpty){
      _limparTudo();
      return;
    }
     double dolar= double.parse(text);
     realController.text= (this.dolar*dolar).toStringAsFixed(2);
     euroController.text=(euro/this.dolar*dolar).toStringAsFixed(2);
  }
  void _mudarEuro(String text){
    if(text.isEmpty){
      _limparTudo();
      return;
    }
      double euro = double.parse(text);
      realController.text= (this.euro*euro).toStringAsFixed(2);
      dolarController.text=(dolar/this.euro*euro).toStringAsFixed(2);
  }

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Conversor de Moedas',style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder:(context,snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child:Text('Carregando...',
                style: TextStyle(color:Colors.amber , fontSize:25),
                textAlign: TextAlign.center),
              );
          default:
            if(snapshot.hasError){
              return Center(
                child:Text('Erro ao carregar dados!',
                style: TextStyle(color:Colors.amber , fontSize:25),
                textAlign: TextAlign.center));
            }else{
              dolar=snapshot.data['results']['currencies']['USD']['buy'];
              euro=snapshot.data['results']['currencies']['EUR']['buy'];
              return SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:<Widget>[
                    Padding(
                      padding:EdgeInsets.only(left: 10, right: 10),
                      child:Column(
                        children: <Widget>[
                            Icon(
                              Icons.monetization_on,
                              size: 150,
                            color:Colors.amber,
                            ),
                            buildTextField(dolarController,_mudarDolar,"Dolar", "UR\$"),
                            Divider(),
                            buildTextField(realController,_mudarReal,"Reais", "R\$"),
                            Divider(),
                            buildTextField(euroController,_mudarEuro,"Euro","€"),
                        ],
                       
                      )
                    )
                  ],
                  ));
              } 
            }
          })
    );
  }
}

Widget buildTextField(controlador,funcao,label, prefix){
    return TextField(
        controller: controlador,
        onChanged: funcao,
        keyboardType: TextInputType.number,
        cursorColor: Colors.amber,
        style: TextStyle(color: Colors.amber,fontSize: 35),
        decoration: InputDecoration(
          labelText: label,                   
          labelStyle:TextStyle(
            color:Colors.amber,                 
            fontSize: 30),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          prefixText: prefix ,
          prefixStyle: TextStyle(color: Colors.amber, fontSize: 35)
        ));
}