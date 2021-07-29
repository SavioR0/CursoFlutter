import 'package:flutter/material.dart';

void main(){
  runApp(new MaterialApp(
    title: 'Aula 2',
    home: new Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController alturaController = new TextEditingController();
  TextEditingController pesoController = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _informacao = 'Informe os campos acima:';
  void _limparCampos(){
    alturaController.text = '';
    pesoController.text = '';
    setState((){
      _informacao= 'Informe os campos acima:';
      _formKey = GlobalKey<FormState>();
    });
}
void _calcular(){
  setState(() {
   var altura = double.parse(alturaController.text)/100;
   var peso=double.parse(pesoController.text);
   var imc=peso/(altura*altura);

   if(imc<18.6){
    _informacao='Abaixo do peso (${imc.toStringAsPrecision(4)})';
   }else if(imc>=18.6 && imc<24.9){
     _informacao='Peso ideal (${imc.toStringAsPrecision(4)})';
   }else if(imc>=18.6 && imc<29.9){
     _informacao='Levemente acima do peso (${imc.toStringAsPrecision(4)})';
   }else if(imc>=18.6 && imc<34.9){
     _informacao='Obesidade grau I (${imc.toStringAsPrecision(4)})';
   }else if(imc>=18.6 && imc<39.9){
     _informacao='Obesidade grau II (${imc.toStringAsPrecision(4)})';
   }else if(imc>=39.9){
     _informacao='Obesidade grau III (${imc.toStringAsPrecision(4)})';
   }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(icon:Icon(Icons.refresh),onPressed: _limparCampos)
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.person_outline, size:120,color:Colors.white),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Peso (kg)',
                    labelStyle: TextStyle(color:Colors.grey)),
                  textAlign: TextAlign.center,
                  style:TextStyle(color:Colors.black, fontSize: 25),
                  controller: pesoController,
                  validator:(value){
                    if(value==num){
                      return 'Informe seu peso!';
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Altura (cm)',
                    labelStyle: TextStyle(color:Colors.grey)),
                  textAlign: TextAlign.center,
                  style:TextStyle(color:Colors.black, fontSize: 25),
                  controller: alturaController,
                  validator:(value){
                    if(value==num){
                      return 'Informe sua altura!';
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom:10),
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          _calcular();
                        }
                      },
                      child:Text('Calcular',
                        style: 
                          TextStyle(color: Colors.black,fontSize:25)),
                        color: Colors.grey,
                      )),
                ),
                Text(
                  _informacao,
                  textAlign: TextAlign.center,
                  style: TextStyle(color:Colors.black,fontSize:25),
                )
              ],
            ),
            
      ),
      ));
  }
}