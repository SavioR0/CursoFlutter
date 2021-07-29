import 'package:cloud_firestore/cloud_firestore.dart';

class DadosProdutos {
  String categoria;
  String id;
  String titulo;
  String descricao;
  double preco;

  List imagens;
  List tamanhos;

  DadosProdutos.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    titulo = snapshot.data["titulo"];
    descricao = snapshot.data["descricao"];
    preco = snapshot.data["preco"] + 0.0;
    imagens = snapshot.data["imagens"];
    tamanhos = snapshot.data["tamanhos"];
  }

  Map<String, dynamic> toResumo() {
    return {
      "titulo": titulo,
      "descricao": descricao,
      "preco": preco,
    };
  }
}
