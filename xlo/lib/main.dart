import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:xlo/blocs/drawer_bloc.dart';
import 'package:xlo/blocs/home_bloc.dart';
import 'package:xlo/screens/base/base_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Passa uma lista de providers para estar disponivel de qualquer lugar do meu app
      providers: [
        Provider<DrawerBloc>(
          create: (_) => DrawerBloc(),
          dispose: (context, value) => value.dispose(),
        ),
        Provider<HomeBloc>(
          create: (_) => HomeBloc(),
          dispose: (context, value) => value.dispose(),
        )
      ],
      child: MaterialApp(
        title: 'XLO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('pt', 'BR')],
        home: BaseScreen(),
      ),
    );
  }
}
