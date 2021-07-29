import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Partes/Categorias.dart';

class ProdutosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //importando dados do Firebase, os dados não vem intantaneamente por isso FutureBuilder, recebendo um query snapshot
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("Produtos").getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //var= quando não se tem uma variável existente
            //Codigo Responsavel por carregar as categorias divididas por uma linha (divider)
            var divisor = ListTile.divideTiles(
                    tiles: snapshot.data.documents.map((doc) {
                      return Categorias(doc);
                    }).toList(),
                    color: Colors.grey[500])
                .toList();
            return ListView(
              children: divisor,
            );
          }
        });
  }
}
