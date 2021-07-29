import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Modelos/ModeloCarrinho.dart';
import 'package:minha_loja_virtual/Modelos/ModeloUsuario.dart';
import 'package:minha_loja_virtual/Partes/ItemCarrinho.dart';
import 'package:minha_loja_virtual/Telas/TelaLogin.dart';
import 'package:minha_loja_virtual/Telas/TelaPedidos.dart';
import 'package:minha_loja_virtual/Widget/Deconto.dart';
import 'package:minha_loja_virtual/Widget/Frete.dart';
import 'package:minha_loja_virtual/Widget/PrecoCarrinho.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaCarrinho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 198, 165),
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<ModeloCarrinho>(
                builder: (context, child, modelo) {
              int n = modelo.produtos.length;
              //se p for nulo, retorna 0, caso contrario , retorna o p
              //Se p for igual a 1 retona ITEM, senão retorna ITENS
              return Text("${n ?? 0} ${n == 1 ? "ITEM" : "ITENS"}");
            }),
          ),
        ],
      ),
      body: ScopedModelDescendant<ModeloCarrinho>(
          builder: (context, child, modelo) {
        //Primerio caso: Usuario esta logado e o carrinho esta carregando
        if (modelo.estaCarregando && ModeloUsuario.of(context).estaLogado()) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
          //Segundo caso : usuario não está logado
        } else if (!ModeloUsuario.of(context).estaLogado()) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              //ocupa o maximo de espaço possivel no eixo principal, no caso é na horizontal
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.remove_shopping_cart,
                  size: 80.0,
                  color: Color.fromARGB(255, 250, 198, 165),
                ),
                SizedBox(height: 16.0),
                Text("Faça o login pra adicionar item em seu carrinho!",
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
          //Se Não possuir nenhum produto no carrinho
        } else if (modelo.produtos == null || modelo.produtos.length == 0) {
          return Center(
            child: Text(
              "Nenhum produto no carrinho!",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 198, 175)),
              textAlign: TextAlign.center,
            ),
          );
          //Usuario está logado e possui produtos no carrinho
        } else {
          //Capaz de rodar a tela quando montar a list
          return ListView(
            children: <Widget>[
              Column(
                  children: modelo.produtos.map((produto) {
                return ItemCarrinho(produto);
              }).toList()),
              Desconto(),
              Frete(),
              PrecoCarrinho(() async {
                String idPedido = await modelo.finalizarPedido();
                if (idPedido != null)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TelaPedidos(idPedido)));
              }),
            ],
          );
        }
      }),
    );
  }
}
