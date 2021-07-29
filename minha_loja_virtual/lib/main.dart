import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Modelos/ModeloCarrinho.dart';
import 'package:minha_loja_virtual/Modelos/ModeloUsuario.dart';
import 'package:minha_loja_virtual/Telas/TelaHome.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ModeloUsuario>(
        //Tudo vai ter acesso á classe ModeloUsuario
        model: ModeloUsuario(),
        //Toda vez que mudar de usuario, eu quero que mude tambem o carrinho
        child: ScopedModelDescendant<ModeloUsuario>(
            builder: (context, child, model) {
          return ScopedModel<ModeloCarrinho>(
            //O model passado de parametro é o Modeloususario de cima
            model: ModeloCarrinho(model),
            child: MaterialApp(
              title: "flutter loja",
              theme: ThemeData(
                primaryColor: Color.fromARGB(
                    255 /*opacidade, cor maxima sem nenhuma transparencia*/,
                    4 /*red*/,
                    125 /*green*/,
                    141 /*blue*/), //varia de 0 a 255
                primarySwatch: Colors.blue,
              ),
              debugShowCheckedModeBanner: false,
              home: TelaHome(),
            ),
          );
        }));
  }
}
