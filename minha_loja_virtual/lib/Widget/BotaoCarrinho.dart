import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Telas/TelaCarrinho.dart';

class BotaoCarrinho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TelaCarrinho(),
        ));
      },
      child: Icon(Icons.shopping_cart),
      backgroundColor: Color.fromARGB(255, 250, 198, 165),
    );
  }
}
