import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Modelos/ModeloUsuario.dart';
import 'package:scoped_model/scoped_model.dart';

class CriarConta extends StatefulWidget {
  @override
  _CriarContaState createState() => _CriarContaState();
}

class _CriarContaState extends State<CriarConta> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _enderecoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 250, 198, 165),
            title: Text("Criar conta"),
            centerTitle: true),
        //valida campos para login por exemplo
        body: ScopedModelDescendant<ModeloUsuario>(
            builder: (context, child, modelo) {
          if (modelo.estaCarregando)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Form(
              key: _chaveFormulario,
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(hintText: "Nome"),
                    cursorColor: Color.fromARGB(255, 250, 198, 165),
                    validator: (texto) {
                      //Valda se o texto está vazio ou se o texto não contém '@'
                      if (texto.isEmpty) return "Nome inválido!";
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-mail"),
                    //aparece o @ no teclado
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color.fromARGB(255, 250, 198, 165),
                    validator: (texto) {
                      //Valda se o texto está vazio ou se o texto não contém '@'
                      if (texto.isEmpty || !texto.contains("@"))
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
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _enderecoController,
                    decoration: InputDecoration(hintText: "Endereço"),
                    //Não aparacer o que digitar
                    cursorColor: Color.fromARGB(255, 250, 198, 165),
                    validator: (texto) {
                      //Valida se o texto estiver vazio ou menor que 6 digitos
                      if (texto.isEmpty) return "Endereço inválido!";
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        'Criar Conta',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Color.fromARGB(255, 250, 198, 165),
                      //Quando pressionado há uma verificação/validação do e-mail e senha colocados
                      onPressed: () {
                        if (_chaveFormulario.currentState.validate()) {
                          Map<String, dynamic> dadosUsuario = {
                            //conteudo do mapa
                            //senha não será armazenada junto com as informacoes do usuario, para a segunrança, e nao ser capaz de acessá-la pelo firebase
                            "nome": _nomeController.text,
                            "email": _emailController.text,
                            "endereco": _enderecoController.text,
                          };
                          modelo.criarUsuario(
                              dadosUsuario: dadosUsuario,
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

  //Resposavel por criar um aviso que o usuario foi criado com sucesso, e sair da pagina de criar um conta
  void _onSuccess() {
    //Para exibir a barra de aviso , precisa-se ter acesso ao scafold
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar o usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
