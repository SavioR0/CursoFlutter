import 'package:flutter/material.dart';

class OpcaoDrawer extends StatelessWidget {
  final IconData icon;
  final String texto;
  final PageController controladorDePaginas;
  final int pagina;

  OpcaoDrawer(this.icon, this.texto, this.controladorDePaginas, this.pagina);
  @override
  Widget build(BuildContext context) {
    //Para ter o efeito visual
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          //Antes de sair da página Precisa-se fechar o drawer
          Navigator.of(context).pop();
          //Vai para a pagina da opção escolhida
          controladorDePaginas.jumpToPage(pagina);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(icon,
                  size: 32,
                  color: controladorDePaginas.page.round() == pagina
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700]),
              //Espaçamento do icone com o texto
              SizedBox(
                width: 32,
              ),
              Text(
                texto,
                style: TextStyle(
                    fontSize: 16.0,
                    color: controladorDePaginas.page == pagina
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
