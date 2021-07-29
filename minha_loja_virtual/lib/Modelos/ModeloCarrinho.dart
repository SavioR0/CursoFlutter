import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:minha_loja_virtual/Dados/ProdutoCarrinho.dart';
import 'package:minha_loja_virtual/Modelos/ModeloUsuario.dart';
import 'package:scoped_model/scoped_model.dart';

class ModeloCarrinho extends Model {
  ModeloUsuario usuario;
  List<ProdutoCarrinho> produtos = [];
  String cupomDesconto;
  int porcetagemDesconto = 0;

  ModeloCarrinho(this.usuario) {
    if (usuario.estaLogado()) {
      _carregarItensDoCarrinho();
    }
  }
  bool estaCarregando = false;

  static ModeloCarrinho of(BuildContext context) =>
      ScopedModel.of<ModeloCarrinho>(context);

  void addProduto(ProdutoCarrinho produtoCarrinho) {
    produtos.add(produtoCarrinho);
    Firestore.instance
        .collection("usuarios")
        .document(usuario.firebaseUser.uid)
        .collection("carrinho")
        .add(produtoCarrinho.toMap())
        .then((doc) {
      produtoCarrinho.cid = doc.documentID;
    });
    notifyListeners();
  }

  void removerProduto(ProdutoCarrinho produtoCarrinho) {
    Firestore.instance
        .collection("usuarios")
        .document(usuario.firebaseUser.uid)
        .collection("carrinho")
        .document(produtoCarrinho.cid)
        .delete();

    produtos.remove(produtoCarrinho);
    notifyListeners();
  }

  void incProduto(ProdutoCarrinho produtoCarrinho) {
    produtoCarrinho.quantidade++;
    Firestore.instance
        .collection("usuarios")
        .document(usuario.firebaseUser.uid)
        .collection("carrinho")
        .document(produtoCarrinho.cid);
    notifyListeners();
  }

  void decProduto(ProdutoCarrinho produtoCarrinho) {
    produtoCarrinho.quantidade--;

    Firestore.instance
        .collection("usuarios")
        .document(usuario.firebaseUser.uid)
        .collection("carrinho")
        .document(produtoCarrinho.cid)
        .updateData(produtoCarrinho.toMap());
    notifyListeners();
  }

  void colocarCupom(String cupomDesconto, int porcentagemDesconto) {
    this.cupomDesconto = cupomDesconto;
    this.porcetagemDesconto = porcentagemDesconto;
  }

  double pegarPrecoDosProdutos() {
    double preco = 0.0;
    for (ProdutoCarrinho c in produtos) {
      if (c.dadosProduto != null) preco += c.quantidade * c.dadosProduto.preco;
    }
    return preco;
  }

  double pegarDescontoDoProduto() {
    return pegarPrecoDosProdutos() * (porcetagemDesconto / 100);
  }

  double pegarFreteDoProduto() {
    return 1.0;
  }

  void updatePrecos() {
    notifyListeners();
  }

  Future<String> finalizarPedido() async {
    if (produtos.length == 0) return null;
    estaCarregando = true;
    notifyListeners();

    double precoDosProdutos = pegarPrecoDosProdutos();
    double precofrete = pegarFreteDoProduto();
    double precoDesconto = pegarDescontoDoProduto();

    //mapa
    DocumentReference refPedido =
        await Firestore.instance.collection("pedidos").add({
      "clienteId": usuario.firebaseUser.uid,
      //armazena uma lista de produto em uma lista de mapas
      "Produtos":
          produtos.map((produtoCarrinho) => produtoCarrinho.toMap()).toList(),
      "frete": precofrete,
      "precoTotal": precoDosProdutos - precoDesconto + precofrete,
      "precoDesconto": precoDesconto,
      "precoProdutos": precoDosProdutos,
      "status": 1,
    });

    await Firestore.instance
        .collection("usuarios")
        .document(usuario.firebaseUser.uid)
        .collection("pedidos")
        .document(refPedido.documentID)
        .setData({"idPedido": refPedido.documentID});

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("usuarios")
        .document(usuario.firebaseUser.uid)
        .collection("carrinho")
        .getDocuments();
    //para cada documento no snapShot deletar todos os produtos do nosso carrinho
    for (DocumentSnapshot doc in querySnapshot.documents) {
      doc.reference.delete();
    }

    produtos.clear();
    cupomDesconto = null;
    porcetagemDesconto = 0;

    estaCarregando = false;
    notifyListeners();
    return refPedido.documentID;
  }

  void _carregarItensDoCarrinho() async {
    QuerySnapshot query = await Firestore.instance
        .collection("usuarios")
        .document(usuario.firebaseUser.uid)
        .collection("carrinho")
        .getDocuments();

    //Retornando uma lista de Produtos do carrinho e mapeando todos os documentos do firebase
    produtos = query.documents
        .map((doc) => ProdutoCarrinho.fromDocument(doc))
        .toList();
    notifyListeners();
  }
}
