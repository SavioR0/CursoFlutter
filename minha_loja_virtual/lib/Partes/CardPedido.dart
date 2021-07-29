import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardPedido extends StatelessWidget {
  String idPedido;
  CardPedido(this.idPedido);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        //O stream olha o tempo todo para o banco de dados pra ver e tem alguma ateração
        child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection("pedidos")
                .document(idPedido)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                int status = snapshot.data["status"];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Código do Pedido: ${snapshot.data.documentID}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(_construirTextoDoProduto(snapshot.data)),
                    SizedBox(height: 4.0),
                    Text(
                      "Status Do Pedido:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _construirStatus("1", "Preparação", status, 1),
                        _linha(),
                        _construirStatus("2", "Transporte", status, 2),
                        _linha(),
                        _construirStatus("3", "Entrega", status, 3),
                      ],
                    )
                  ],
                );
              }
            }),
      ),
    );
  }

  String _construirTextoDoProduto(DocumentSnapshot snapshot) {
    String texto = "Descrição: \n";
    //A lista de produtos no firebase, não é uma lista comum, nesse caso é uma linkedHash
    //Pra cada um dos nosso pedidos
    for (LinkedHashMap p in snapshot["Produtos"]) {
      texto +=
          "${p["quantidade"]} x ${p["produto"]["titulo"]} (R\$ ${p["produto"]["preco"].toStringAsFixed(2)})\n";
    }
    texto += "Total: R\$ ${snapshot.data["precoTotal"].toStringAsFixed(2)}";
    return texto;
  }

  Widget _construirStatus(
      String titulo, String subtitulo, int status, int thisStatus) {
    Color corFundo;
    Widget child;

    if (status < thisStatus) {
      corFundo = Colors.grey;
      child = Text(titulo, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      corFundo = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(titulo, style: TextStyle(color: Colors.white)),
          //Animação do circulo girando em volta
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        ],
      );
    } else {
      corFundo = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: corFundo,
          child: child,
        ),
        Text(subtitulo),
      ],
    );
  }

  Widget _linha() {
    return Container(
      height: 1.0,
      width: 40.0,
      color: Colors.grey[500],
    );
  }
}
