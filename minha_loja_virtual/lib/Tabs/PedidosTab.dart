import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Modelos/ModeloUsuario.dart';
import 'package:minha_loja_virtual/Partes/CardPedido.dart';
import 'package:minha_loja_virtual/Telas/TelaLogin.dart';

class PedidosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (ModeloUsuario.of(context).estaLogado()) {
      //Poder acessar os pedidos do usuario
      String uid = ModeloUsuario.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("usuarios")
            .document(uid)
            .collection("pedidos")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
            return ListView(
              children: snapshot.data.documents
                  .map((doc) => CardPedido(doc.documentID))
                  .toList()
                  //Para construir a lista de cima pra baixo
                  .reversed
                  .toList(),
            );
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          //ocupa o maximo de espaço possivel no eixo principal, no caso é na horizontal
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.view_headline,
              size: 80.0,
              color: Color.fromARGB(255, 250, 198, 165),
            ),
            SizedBox(height: 16.0),
            Text("Faça o login para acompanhar seus pedidos!",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 250, 198, 165)),
                textAlign: TextAlign.center),
            SizedBox(height: 16.0),
            RaisedButton(
              child: Text("Entrar", style: TextStyle(fontSize: 18.0)),
              onPressed: () {
                return Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TelaLogin(),
                ));
              },
            ),
          ],
        ),
      );
    }
  }
}
