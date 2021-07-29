import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlo/blocs/drawer_bloc.dart';
import 'package:xlo/screens/account/account_screen.dart';
import 'package:xlo/screens/create/create_screen.dart';
import 'package:xlo/screens/home/home_screen.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  //Declarando o responsavel por mudar as paginas
  final PageController _pageController = PageController();

  DrawerBloc _drawerBloc;
  StreamSubscription _drawerSubscription;

  //Função necessaria para que eu tenha acesso ao meu bloc em um stateful
  //Aqui há a mudança de paginas, utilizando o bloc do drawer
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //Ele consegue achar o bloc por ter um context
    final DrawerBloc drawerBloc = Provider.of<DrawerBloc>(context);
    if (drawerBloc != _drawerBloc) {
      _drawerBloc = drawerBloc;

      //Para não ocupar memoria , antes de criar uma nova stream, ele cancela a antiga e adiciona a nova
      //A interrogação serve para que: Se for nulo, o cancel não executa
      _drawerSubscription?.cancel();
      _drawerSubscription = _drawerBloc.outPage.listen((page) {
        try {
          _pageController.jumpToPage(page);
        } catch (e) {}
      });
    }
  }

  @override
  void dispose() {
    _drawerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        //Capaz de controlar as paginas começando do 0
        controller: _pageController,
        //Não passar de uma tela pra outra ao arrastar pro lado
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomeScreen(),
          CreateScreen(),
          Container(color: Colors.red),
          Container(color: Colors.blue),
          AccountScreen(),
        ],
      ),
    );
  }
}
