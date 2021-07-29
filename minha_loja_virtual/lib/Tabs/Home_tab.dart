import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _papelDeParede() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  //Faz uma tela degradê, no caso duas cores , rosa claro e escuro
                  colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        );
    return Stack(
      //conteudo acima do fundo degradê
      children: <Widget>[
        _papelDeParede(),
        CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            floating: true, //desaparece
            snap: true, //sobe de acordo com a rolagem da pagina
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Novidades"),
              centerTitle: true,
            ),
          ),
          FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("home")
                  .orderBy("pos")
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) //Se for diferente de estar carregado
                  return SliverToBoxAdapter(
                    //Dentro do SchollView, todos os compodentes devem ser do tipo sliver
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    ),
                  );
                else
                  return SliverStaggeredGrid.count(
                    //count porque temos um numero predeterminado que será carregado
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    staggeredTiles: snapshot.data.documents.map((doc) {
                      return StaggeredTile.count(doc.data["x"], doc.data["y"]);
                    }).toList(),
                    children: snapshot.data.documents.map((doc) {
                      return FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: doc.data["img"],
                        //cubra todo o espaço possivel na grade
                        fit: BoxFit.cover,
                      ); //imagem que vai aparecer suavemente
                    }).toList(),
                  );
              })
        ])
      ],
    );
  }
}
