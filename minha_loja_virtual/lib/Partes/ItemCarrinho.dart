import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Dados/DadosProdutos.dart';
import 'package:minha_loja_virtual/Dados/ProdutoCarrinho.dart';
import 'package:minha_loja_virtual/Modelos/ModeloCarrinho.dart';

class ItemCarrinho extends StatelessWidget {
  final ProdutoCarrinho produtoCarrinho;
  ItemCarrinho(this.produtoCarrinho);

  @override
  Widget build(BuildContext context) {
    Widget _construtor() {
      ModeloCarrinho.of(context).updatePrecos();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8.0)),
          //imagem do produto
          Container(
            width: 120.0,
            child: Image.network(
              produtoCarrinho.dadosProduto.imagens[0],
              //ocupar todo o espaço possivel
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //igualmente espaçado
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    produtoCarrinho.dadosProduto.titulo,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text("Tamanho: ${produtoCarrinho.tamanho}",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Text(
                    "R\$ ${produtoCarrinho.dadosProduto.preco.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    //Igualmente espaçado entre um item e outro
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: produtoCarrinho.quantidade > 1
                            ? () {
                                ModeloCarrinho.of(context)
                                    .decProduto(produtoCarrinho);
                              }
                            : null,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(produtoCarrinho.quantidade.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          ModeloCarrinho.of(context)
                              .incProduto(produtoCarrinho);
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                      FlatButton(
                        onPressed: () {
                          ModeloCarrinho.of(context)
                              .removerProduto(produtoCarrinho);
                        },
                        child: Text("Remover"),
                        color: Colors.grey[500],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
        //Margem da uma distancia pra fora do widget , e o padding da uma distancia pra dentro do widget
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        //Se ainda nao temos os dados do produto , entao ele busca no banco de dados e salva no dadosProdutos
        child: produtoCarrinho.dadosProduto == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection("Produtos")
                    .document(produtoCarrinho.categoria)
                    .collection("itens")
                    .document(produtoCarrinho.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //quando se obtem os dados, salva os dados pra se usar depois
                    produtoCarrinho.dadosProduto =
                        DadosProdutos.fromDocument(snapshot.data);
                    //retorna um widget que constroi o card com os dados
                    return _construtor();
                  } else {
                    //Enquanto não estiver dado, retorna um container com CircularProgressIndicator
                    return Container(
                      height: 70.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                })
            //senao, ja retorna direto o widget
            : _construtor());
  }
}
