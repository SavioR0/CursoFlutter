import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Dados/DadosProdutos.dart';
import 'package:minha_loja_virtual/Telas/TelaProduto.dart';

class ItemProduto extends StatelessWidget {
  final String tipo;
  final DadosProdutos produto;

  ItemProduto(this.tipo, this.produto);
  @override
  Widget build(BuildContext context) {
    //Inkwell diferente do gesture Detector , possui uma animação ao tocar
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TelaProduto(produto)));
      },
      child: Card(
          child: tipo == "grid"
              ? Column(
                  //stretch porque as coisas estao esticadas
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //AspectRatio não deixa que o tamanho do seu conteudo varie de acordo com o dispositivo
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: Image.network(produto.imagens[0],
                          //ocupa todo o espaço disponivel
                          fit: BoxFit.cover),
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            produto.titulo,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'R\$ ${produto.preco.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),
                  ],
                )
              : Row(
                  children: <Widget>[
                    //flexible consegue dividir. Ex: flex 1 e 2 , o 2 Sera o dobro do tamanho
                    Flexible(
                      flex: 1,
                      child: Image.network(produto.imagens[0],
                          fit: BoxFit.cover, height: 250.0),
                    ),
                    Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                produto.titulo,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'R\$${produto.preco.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )),
                  ],
                )),
    );
  }
}
