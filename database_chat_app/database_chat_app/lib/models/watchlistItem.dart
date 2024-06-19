// ignore_for_file: file_names

class Stock {
  final String symbol;

  final String change;
  final String changePercentage;
  final String current;
  final int quantity;
  final double totalCost;
  Stock({
    required this.symbol,
    required this.change,
    required this.changePercentage,
    required this.current,
    required this.quantity,
    required this.totalCost,
  });

  Map<String, dynamic> toMap() {
    return {
      // You may need to handle this if your Stock model has an ID field
      'symbol': symbol,
      'current': current,
      'change': change,
      'changePercentage': changePercentage,
      'quantity': quantity,
      'totalCost': totalCost,
    };
  }

  // Create a Stock object from a Map
  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      symbol: map['symbol'],
      current: map['current'],
      change: map['change'],
      changePercentage: map['changePercentage'],
      quantity: map['quantity'],
      totalCost: map['totalCost'],
    );
  }
}
