class Stock {
  final String symbol;
  final String name;
  final double latestPrice;

  Stock({
    required this.symbol,
    required this.name,
    required this.latestPrice,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['1. symbol'] ?? '',
      name: json['2. name'] ?? '',
      latestPrice: double.tryParse(json['5. price'] ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'latestPrice': latestPrice,
    };
  }
}