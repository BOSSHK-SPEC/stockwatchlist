import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockwatchlist/view/helper/MyNavigationBar.dart';
import 'package:stockwatchlist/view/watchlistPage.dart';

import '../model/stockModel.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _screens = [HomeContent(), watchlistPage()];
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      bottomNavigationBar: MyNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
      body: _screens[_currentIndex],
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();

  List<Stock> _searchResults = [];

  Future<void> searchStocks(String query) async {
    const apiKey = 'QHHYFQEF687DTYZV';
    final apiUrl =
        'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$query&apikey=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));
    print(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final stocks = data['bestMatches'] as List<dynamic>;
      setState(() {
        _searchResults = stocks.map((stock) => Stock.fromJson(stock)).toList();
      });
    } else {
      throw Exception('Failed to fetch stocks');
    }
  }

  Future<void> addToWatchlist(Stock stock) async {
    final prefs = await SharedPreferences.getInstance();
    final watchlist = prefs.getStringList('watchlist') ?? [];

    final stockJson =
    stock.toJson(); // Assuming Stock class has a `toJson` method

    watchlist.add(json.encode(stockJson));
    await prefs.setStringList('watchlist', watchlist);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to watchlist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (query) {
              if (query.isNotEmpty) {
                searchStocks(query);
              }
            },
            decoration: InputDecoration(
              labelText: 'Search',
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final stock = _searchResults[index];
              print(stock);
              return ListTile(
                title: Text(stock.symbol),
                subtitle: Text(stock.name),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addToWatchlist(stock);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
