import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:minha_loja_virtual/Dados/DadosProdutos.dart';
import 'package:minha_loja_virtual/Dados/ProdutoCarrinho.dart';
import 'package:minha_loja_virtual/Modelos/ModeloCarrinho.dart';
import 'package:minha_loja_virtual/Modelos/ModeloUsuario.dart';
import 'package:minha_loja_virtual/Telas/TelaCarrinho.dart';
import 'package:minha_loja_virtual/Telas/TelaLogin.dart';

class TelaProduto extends StatefulWidget {
  final DadosProdutos produto;
  TelaProduto(this.produto);

  @override
  _TelaProdutoState createState() => _TelaProdutoState(produto);
}

class _TelaProdutoState extends State<TelaProduto> {
  //Estou declarando novo construtor para ser mais facil chamar o produto no build,  ao inves de colocar widget.produto, agora sera só produto
  final DadosProdutos produto;
  _TelaProdutoState(this.produto);
  String tamanho;
  @override
  Widget build(BuildContext context) {
    final Color corPrimaria = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.titulo),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            //Lugar onde vao ficar as imagens
            child: Carousel(
              //as imagens estao em url tranformando em lista no final
              images: produto.imagens.map((url) {
                return Image.network(url);
              }).toList(),
              //tamanho dos pontos
              dotSize: 4.0,
              //espaçamento dos pontos
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              //cor dos pontos quando se autera as imagens
              dotColor: corPrimaria,
              //muda as imagens automaticamente
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              //ocupar o maximo de espaço possivel com o stretch
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  produto.titulo,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  //Va ocupar no maximo 3 linhas
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${produto.preco.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: corPrimaria),
                ),
                //Coloca um espaçamento
                SizedBox(height: 16.0),
                Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    //Eixo de rolamento será na horizontal, o padrao é que seja na vertical
                    scrollDirection: Axis.horizontal,
                    //mesma utilizada para  mostrar a grade de produtos
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: produto.tamanhos.map((tam) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            tamanho = tam;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              //borda arredondada
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                  color: tamanho == tam
                                      ? corPrimaria
                                      : Colors.grey[500],
                                  width: 3.0)),
                          width: 50.0,
                          //texto bem no centro do container
                          alignment: Alignment.center,
                          child: Text(tam),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      //quando o tamanho nao ser selecionado , o botao fica desabilitado automaticamente
                      onPressed: tamanho != null
                          ? () {
                              //Acessar o modelo sem precisar usar o ScopedModeldecendent
                              if (ModeloUsuario.of(context).estaLogado()) {
                                //adicionar ao carrinho
                                ProdutoCarrinho produtoCarrinho =
                                    ProdutoCarrinho();

                                produtoCarrinho.tamanho = tamanho;
                                produtoCarrinho.pid = produto.id;
                                produtoCarrinho.quantidade = 1;
                                produtoCarrinho.categoria = produto.categoria;
                                produtoCarrinho.dadosProduto = produto;

                                ModeloCarrinho.of(context)
                                    .addProduto(produtoCarrinho);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TelaCarrinho()));
                              } else {
                                //a construção objeto.of(context) está procurando o objeto na arvore
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TelaLogin(),
                                ));
                              }
                            }
                          : null,
                      child: Text(
                        ModeloUsuario.of(context).estaLogado()
                            ? "Adicionar ao Carrinho"
                            : "Entre para comprar",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      color: corPrimaria,
                      textColor: Colors.white,
                    )),
                SizedBox(height: 16.0),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  produto.descricao,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
