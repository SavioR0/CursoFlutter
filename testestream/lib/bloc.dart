import 'dart:async';

/*class ContadorBloc {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}*/
class ContadorBloc {
  List<int> lista = new List();
  int counter = -1;

  final streamController = StreamController<List<int>>();
  // criamos o counter que será um streamcontroller para podermos ouvi-lo na nossa UI

  void incrementCounter() {
    counter = counter + 1;
    // aqui realizamos uma simples mudança para que vá acrescentando o 1 a cada clique
    lista[lista.length] = counter;
    streamController.add(lista);
    // vamos adicionar ao nosso stream o valor de _counter
  }

  // nunca esqueça de dar o dispose, para que sua aplicação não utilize recursos desnecessariamente
  void dispose() {
    streamController.close();
  }
}
