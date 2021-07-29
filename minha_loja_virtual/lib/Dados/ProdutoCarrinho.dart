import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minha_loja_virtual/Dados/DadosProdutos.dart';

class ProdutoCarrinho {
  String cid;
  String categoria;
  String pid;
  int quantidade;
  String tamanho;

  DadosProdutos dadosProduto;

  ProdutoCarrinho();

  //document será uma dos produtos que será armazenado no carrinho
  ProdutoCarrinho.fromDocument(DocumentSnapshot documento) {
    cid = documento.documentID;
    categoria = documento.data["categoria"];
    pid = documento.data["pid"];
    quantidade = documento.data["quantidade"];
    tamanho = documento.data["tamanho"];
  }

  //Para adicionar o produto no carrinho , e colocar no banco de dados , precisa-se tranformar os dados em um map
  Map<String, dynamic> toMap() {
    return {
      "categoria": categoria,
      "tamanho": tamanho,
      "quantidade": quantidade,
      "pid": pid,
      "produto": dadosProduto.toResumo(),
    };
  }
}
