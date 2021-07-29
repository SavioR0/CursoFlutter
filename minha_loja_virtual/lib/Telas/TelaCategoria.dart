import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Dados/DadosProdutos.dart';
import 'package:minha_loja_virtual/Partes/ItemProduto.dart';

class TelaCategoria extends StatelessWidget {
  final DocumentSnapshot snapshot;
  TelaCategoria(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data["titulo"]),
              centerTitle: true,
              bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(icon: Icon(Icons.list))
              ]),
            ),
            //QuerySnapshot =coleção  DocumentSnapshot= apenas um documento
            body: FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection("Produtos")
                    .document(snapshot.documentID)
                    .collection("itens")
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return TabBarView(
                        //impedir que a troca de tela seja feita arrastando pro lado, e sim, clicando na tabBar
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          //necessario que seja .builder
                          GridView.builder(
                            padding: EdgeInsets.all(4.0),
                            //gridDelegate diz  quantidade de item que devem ser carregados
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              //razão entre a altura e largura de cada item do gridView
                              childAspectRatio: 0.65,
                            ),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              DadosProdutos dados = DadosProdutos.fromDocument(
                                  snapshot.data.documents[index]);
                              //setando a categoria do produto
                              dados.categoria = this.snapshot.documentID;
                              return ItemProduto("grid", dados);
                            },
                          ),
                          ListView.builder(
                              padding: EdgeInsets.all(4.0),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DadosProdutos dados =
                                    DadosProdutos.fromDocument(
                                        snapshot.data.documents[index]);
                                //setando a categoria do produto
                                dados.categoria = this.snapshot.documentID;
                                return ItemProduto("list", dados);
                              })
                        ]);
                  }
                })));
  }
}
