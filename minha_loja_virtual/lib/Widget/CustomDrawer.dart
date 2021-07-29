import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Modelos/ModeloUsuario.dart';
import 'package:minha_loja_virtual/Partes/OpcaoDrawer.dart';
import 'package:minha_loja_virtual/Telas/TelaLogin.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController controladorDePaginas;
  CustomDrawer(this.controladorDePaginas);

  @override
  Widget build(BuildContext context) {
    Widget _drawerpapelDeParede() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  //Faz uma tela degradê, no caso duas cores , rosa claro e escuro
                  colors: [Color.fromARGB(255, 250, 198, 165), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _drawerpapelDeParede(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        "Loja Flutter", //Para quebrar a linha pra que caiba na tela é só colocar o \n no texto desejado
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      child: ScopedModelDescendant<ModeloUsuario>(
                          builder: (context, child, modelo) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Olá, ${!modelo.estaLogado() ? "" : modelo.dadosUsuario["nome"]}",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              child: Text(
                                  !modelo.estaLogado()
                                      ? "Entre ou cadastre-se >"
                                      : "Sair",
                                  style: TextStyle(
                                      //Utiliza a cor primária colocada no tema do projeto
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              onTap: () {
                                !modelo.estaLogado()
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => TelaLogin()))
                                    : modelo.sairLogin();
                              },
                            )
                          ],
                        );
                      }),
                    )
                  ],
                ),
              ),
              Divider(),
              OpcaoDrawer(Icons.home, "Início", controladorDePaginas, 0),
              OpcaoDrawer(Icons.list, "Produtos", controladorDePaginas, 1),
              OpcaoDrawer(Icons.location_on, "Lojas", controladorDePaginas, 2),
              OpcaoDrawer(Icons.playlist_add_check, "Meus Pedidos",
                  controladorDePaginas, 3),
            ],
          ),
        ],
      ),
    );
  }
}
