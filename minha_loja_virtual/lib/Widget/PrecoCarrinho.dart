import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Modelos/ModeloCarrinho.dart';
import 'package:scoped_model/scoped_model.dart';

class PrecoCarrinho extends StatelessWidget {
  final VoidCallback comprar;
  PrecoCarrinho(this.comprar);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<ModeloCarrinho>(
            builder: (context, child, modelo) {
          double preco = modelo.pegarPrecoDosProdutos();
          double desconto = modelo.pegarDescontoDoProduto();
          double frete = modelo.pegarFreteDoProduto();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Resumo do pedido",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Subtotal",
                  ),
                  Text(
                    "R\$ ${preco.toStringAsFixed(2)}",
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Desconto",
                  ),
                  Text(
                    "R\$ -${desconto.toStringAsFixed(2)}",
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Entrega",
                  ),
                  Text(
                    "R\$ ${frete.toStringAsFixed(2)}",
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total", style: TextStyle(fontWeight: FontWeight.w500)),
                  Text(
                    "R\$ ${(preco - desconto + frete).toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 16.0, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              RaisedButton(
                child: Text("Finalizar Pedido"),
                textColor: Colors.white,
                color: Color.fromARGB(255, 250, 198, 165),
                onPressed: comprar,
              ),
            ],
          );
        }),
      ),
    );
  }
}
