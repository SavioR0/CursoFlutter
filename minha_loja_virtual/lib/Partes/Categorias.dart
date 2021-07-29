import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Telas/TelaCategoria.dart';

//Responsavel por pegar o icone e o nome da categoria no firebase

class Categorias extends StatelessWidget {
  final DocumentSnapshot snapshot;
  Categorias(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      //icone
      leading: CircleAvatar(
        radius: 22.0,
        backgroundColor: Color.fromARGB(255, 250, 198, 165),
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["titulo"]),
      //seta que fica no final da linha '>'
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TelaCategoria(snapshot)));
      },
    );
  }
}
