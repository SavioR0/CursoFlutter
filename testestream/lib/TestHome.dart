import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:testestream/bloc.dart';

class TestHome extends StatelessWidget {
  final bloc = ContadorBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: // Aqui iremos colocar um streambuilder para que fique escutando a nossa variável counter
          StreamBuilder(
              stream: bloc.streamController.stream,
              initialData: [],
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: bloc.counter + 1,
                    itemBuilder: (context, index) {
                      return Container(
                          child: Card(
                        child: Text(
                          '${snapshot.data[index]}',
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ));
                    });
              }),
      floatingActionButton: FloatingActionButton(
        // chamando nossa função de incrementar
        onPressed: bloc.incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
