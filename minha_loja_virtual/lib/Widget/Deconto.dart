import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Modelos/ModeloCarrinho.dart';

class Desconto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      //Uma tile que se expande ao clicar , para mostrar seu conteudo
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(
          Icons.card_giftcard,
        ),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu Cupom"),
              initialValue: ModeloCarrinho.of(context).cupomDesconto ?? "",
              onFieldSubmitted: (text) {
                Firestore.instance
                    .collection("cupons")
                    .document(text)
                    .get()
                    .then((docSnap) {
                  //Validando se o cumpom realmente existe
                  if (docSnap.data != null) {
                    ModeloCarrinho.of(context)
                        .colocarCupom(text, docSnap.data["porcento"]);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Deconto de -${docSnap.data["porcento"]}% aplicado!",
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  } else {
                    ModeloCarrinho.of(context).colocarCupom(null, 0);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Cupom de desconto não existente",
                      ),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
