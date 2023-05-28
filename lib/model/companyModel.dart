class Company {
  final String name;
  final String symbol;
  double latestPrice;

  Company({
    required this.name,
    required this.symbol,
    required this.latestPrice,
  });
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      symbol: json['symbol'],
      name: json['name'],
      latestPrice: json['latestPrice'],
    );
  }

  // factory Company.fromJson(Map<String, dynamic> json) {
  //   final name = json['2. name'] ?? '';
  //   final symbol = json['1. symbol'] ?? '';
  //   return Company(
  //     name: name,
  //     symbol: symbol,
  //     latestPrice: 0.0,
  //   );
  // }
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'latestPrice': latestPrice,
    };
  }
}