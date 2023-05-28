import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/companyModel.dart';

class watchlistPage extends StatefulWidget {
  @override
  _watchlistPageState createState() => _watchlistPageState();
}

class _watchlistPageState extends State<watchlistPage> {
  List<Company> _watchlist = [];

  Future<void> fetchWatchlistStocks() async {
    final prefs = await SharedPreferences.getInstance();
    final stocks = prefs.getStringList('watchlist') ?? [];
    print(stocks);
    for (var stock in stocks) {
      try {
        var decodedStock = json.decode(stock);
        print(decodedStock);
        var company = Company.fromJson(decodedStock);
        if (company.symbol != null) {
          print('Symbol: ${company.symbol}');
          print('Name: ${company.name}');
          print('Latest Price: ${company.latestPrice}');
          _watchlist.add(company);
        } else {
          print('Invalid company data: $decodedStock');
        }
      } catch (e) {
        print('Error decoding stock: $e');
      }
    }

    setState(() {
      // _watchlist = List<Company>.from(stocks.map((stock) => Company.fromJson(json.decode(stock))));
      print(_watchlist);
    });
    for (var company in _watchlist) {
      print('Symbol: ${company.symbol}');
      print('Latest Price: ${company.latestPrice}');
      // Access and print other instance variables as needed
    }

    print(_watchlist.first);

    await updateStockPrices(); // Fetch the latest share prices for the watchlist stocks
  }

  Future<void> updateStockPrices() async {
    final apiKey = 'QHHYFQEF687DTYZV';

    for (var i = 0; i < _watchlist.length; i++) {
      print(_watchlist.length);
      final stockSymbol = _watchlist[i].symbol;
      print(stockSymbol);
      final apiUrl =
          'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$stockSymbol&apikey=$apiKey';
      final response = await http.get(Uri.parse(apiUrl));
      print(response);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final latestPrice = double.parse(jsonData['Global Quote']['05. price']);
        setState(() {
          _watchlist[i].latestPrice = latestPrice;
        });
      } else {
        // Handle API error
        print('API request failed with status code: ${response.statusCode}');
      }
    }
  }

  // Future<void> fetchWatchlistStocks() async {
  //   // Retrieve the saved stocks from local storage (shared_preferences)
  //   // Implement your own logic here
  //   // Example:
  //   // final stocks = await SharedPreferences.getInstance().then((prefs) {
  //   //   return prefs.getStringList('watchlist') ?? [];
  //   // });
  //   // setState(() {
  //   //   _watchlist = List<Company>.from(stocks.map((stock) => Company.fromJson(json.decode(stock))));
  //   // });
  //
  //   // Fetch the latest share prices for the watchlist stocks
  //   final apiKey = 'YOUR_API_KEY';
  //   for (var i = 0; i < _watchlist.length; i++) {
  //     final stockSymbol = _watchlist[i].symbol;
  //     final apiUrl = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$stockSymbol&apikey=$apiKey';
  //     final response = await http.get(Uri.parse(apiUrl));
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       final latestPrice = double.parse(jsonData['Global Quote']['05. price']);
  //       setState(() {
  //         _watchlist[i].latestPrice = latestPrice;
  //       });
  //     } else {
  //       // Handle API error
  //       print('API request failed with status code: ${response.statusCode}');
  //     }
  //   }
  // }

  // void removeFromWatchlist(Company company) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final stocks = prefs.getStringList('watchlist') ?? [];
  //
  //   stocks.remove(json.encode(company.toJson()));
  //   await prefs.setStringList('watchlist', stocks);
  //
  //   setState(() {
  //     _watchlist.removeWhere((stock) => stock.symbol == company.symbol);
  //   });
  // }
  void removeFromWatchlist(Company company) async {
    final prefs = await SharedPreferences.getInstance();
    final stocks = prefs.getStringList('watchlist') ?? [];

    stocks.remove(json.encode(company.toJson()));
    await prefs.setStringList('watchlist', stocks);

    setState(() {
      _watchlist.removeWhere((stock) => stock.symbol == company.symbol);
    });

    // Navigate back to the watchlist page with replacement
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => watchlistPage()),
    // );
  }

  DataTable buildWatchlistTable() {
    double total = 0.0;

    List<DataRow> rows = _watchlist.map((company) {
      total += company.latestPrice;

      return DataRow(cells: [
        DataCell(Text(company.symbol)),
        DataCell(Text(company.name)),
        DataCell(Text(company.latestPrice.toString())),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              removeFromWatchlist(company);
            },
          ),
        ),
      ]);
    }).toList();

    rows.add(
      DataRow(cells: [
        DataCell(Text('Total:')),
        DataCell(Text('')),
        DataCell(Text(total.toString())),
        DataCell(Text('')),
      ]),
    );

    return DataTable(
      columns: const [
        DataColumn(label: Text('Symbol')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Latest Price')),
        DataColumn(label: Text('Action')),
      ],
      rows: rows,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchWatchlistStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
        ),
        body: buildWatchlistTable()
        // ListView.builder(
        //   itemCount: _watchlist.length,
        //   itemBuilder: (context, index) {
        //     final company = _watchlist[index];
        //     return ListTile(
        //       title: Text(company.name),
        //       subtitle: Text('Latest Price: ${company.latestPrice}'),
        //       trailing: IconButton(
        //         icon: Icon(Icons.delete),
        //         onPressed: () {
        //           removeFromWatchlist(company);
        //         },
        //       ),
        //     );
        //   },
        // ),
        );
  }
}
