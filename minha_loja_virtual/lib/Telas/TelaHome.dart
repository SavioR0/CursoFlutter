import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Tabs/Home_tab.dart';
import 'package:minha_loja_virtual/Tabs/PedidosTab.dart';
import 'package:minha_loja_virtual/Tabs/ProdutosTab.dart';
import 'package:minha_loja_virtual/Widget/BotaoCarrinho.dart';
import 'package:minha_loja_virtual/Widget/CustomDrawer.dart';

class TelaHome extends StatelessWidget {
  final _controladorDePaginas = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controladorDePaginas,
      physics:
          NeverScrollableScrollPhysics(), //PageView nao muda se arrastar pro lado
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_controladorDePaginas),
          floatingActionButton: BotaoCarrinho(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 250, 198, 165),
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_controladorDePaginas),
          floatingActionButton: BotaoCarrinho(),
          body: ProdutosTab(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 250, 198, 165),
            title: Text("Lojas"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_controladorDePaginas),
          floatingActionButton: BotaoCarrinho(),
          body: Container(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 250, 198, 165),
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_controladorDePaginas),
          body: PedidosTab(),
        ),
      ],
    );
  }
}
