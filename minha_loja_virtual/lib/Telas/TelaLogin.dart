import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Modelos/ModeloUsuario.dart';
import 'package:minha_loja_virtual/Telas/criarConta.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  //chave para verificação de validações
  final _chaveFormulario = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 198, 165),
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                //não será necessario o usuario ir pra tela de login novamente , por isso diferente do push o pushReplacement, que subtitui a tela de login e autentica o usuario direto quando ele cria a conta
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => CriarConta()));
              },
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(fontSize: 10.0),
              ),
              textColor: Colors.white,
            ),
          ],
        ),
        body: ScopedModelDescendant<ModeloUsuario>(
            builder: (context, child, modelo) {
          if (modelo.estaCarregando)
            return Center(
              child: CircularProgressIndicator(),
            );
          //valida campos para login por exemplo
          return Form(
              key: _chaveFormulario,
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-mail"),
                    //aparece o @ no teclado
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color.fromARGB(255, 250, 198, 165),
                    validator: (text) {
                      //Valida se o texto está vazio ou se o texto não contém '@'
                      if (text.isEmpty || !text.contains("@"))
                        return "E-mail inválido!";
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _senhaController,
                    decoration: InputDecoration(hintText: "Senha"),
                    //Não aparacer o que digitar
                    obscureText: true,
                    cursorColor: Color.fromARGB(255, 250, 198, 165),
                    validator: (texto) {
                      //Valida se o texto estiver vazio ou menor que 6 digitos
                      if (texto.isEmpty || texto.length < 6)
                        return "Senha inválida!";
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Insira um e-mail para recuperção"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ));
                        } else {
                          modelo.recuperarSenha(_emailController.text);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Confira seu e-mail"),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: Text(
                        "Esqueci minha senha",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      //exclui o padding que ja vem de padrão no flatButtom
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Color.fromARGB(255, 250, 198, 165),
                      //Quando pressionado há uma verificação/validação do e-mail e senha colocados
                      onPressed: () {
                        if (_chaveFormulario.currentState.validate()) {
                          modelo.login(
                              email: _emailController.text,
                              senha: _senhaController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail);
                        }
                      },
                    ),
                  )
                ],
              ));
        }));
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao entrar"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
