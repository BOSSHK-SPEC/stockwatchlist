import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stockwatchlist/hive/boxes.dart';
import 'package:stockwatchlist/hive/stock_model.dart';
import 'package:stockwatchlist/view/homePage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stockwatchlist/view/watchlistPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 // await Hive.initFlutter();
 // Hive.registerAdapter<Stock>(StockAdapter());
  //await Hive.openBox<Stock>('stocks');
 // boxPerson=await Hive.openBox<Stock>('stocks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/watchlist': (context) => watchlistPage(),
      },
    );
  }
}


