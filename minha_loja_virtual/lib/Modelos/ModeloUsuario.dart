import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//É necessirio que seja extends
//Model= Um objeto que guarda os estados do usuário
//A intenção é acessar de qualque lugar do app
class ModeloUsuario extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //se não tiver um usuário, fisebaseUser vai estar null, senao vai conter o id do usuario e informações basicas
  FirebaseUser firebaseUser;

  Map<String, dynamic> dadosUsuario = Map();

  bool estaCarregando = false;
  //Para acessar o modelo de uma forma mais facil sem precisar usar o scopedModelDecendent
  static ModeloUsuario of(BuildContext context) =>
      ScopedModel.of<ModeloUsuario>(context);

  //aplicativo ja carrega o usuario logado
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _carregarUsuarioAtual();
  }

  //para não esquecer de nada na hora de chamar a função , colocar todos opcionas e com @required
  void criarUsuario(
      {@required Map<String, dynamic> dadosUsuario,
      @required String senha,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    estaCarregando = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: dadosUsuario["email"], password: senha)
        //se der tudo certo
        .then((usuario) async {
      firebaseUser = usuario;
      await _salvarDadosUsuario(dadosUsuario);

      onSuccess();
      estaCarregando = false;
      notifyListeners();
      //Se tiver dado erro
    }).catchError((e) {
      onFail();
      estaCarregando = false;
      notifyListeners();
    });
  }

  bool estaLogado() {
    return firebaseUser != null;
  }

  void login(
      {@required String email,
      @required String senha,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    estaCarregando = true;
    //Tudo que estiver dentro do scopedModelDecendant será recriado, como se fosse um setState
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((usuario) async {
      firebaseUser = usuario;
      await _carregarUsuarioAtual();
      onSuccess();
      notifyListeners();
      estaCarregando = false;
    }).catchError((e) {
      onFail();
      estaCarregando = false;
      notifyListeners();
    });
  }

  //retorna true se o usuario for diferente de null
  void sairLogin() async {
    //Função deslogar
    await _auth.signOut();
    dadosUsuario = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<Null> _salvarDadosUsuario(Map<String, dynamic> dadosUsuario) async {
    this.dadosUsuario = dadosUsuario;
    await Firestore.instance
        .collection("usuarios")
        .document(firebaseUser.uid)
        //setando todos os dados
        .setData(dadosUsuario);
  }

  Future<Null> _carregarUsuarioAtual() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    //Se o usuario logou com sucesso
    if (firebaseUser != null) {
      if (dadosUsuario["nome"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("usuarios")
            .document(firebaseUser.uid)
            .get();
        dadosUsuario = docUser.data;
      }
    }
    notifyListeners();
  }

  void recuperarSenha(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }
}

class ModleoUsuario {}
