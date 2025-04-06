class BillItem {
  final String productId;
  final String name;
  final double price;
  int quantity;

  BillItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
  };
}

class Bill {
  final String id;
  final String customerName;
  final DateTime timestamp;
  final List<BillItem> items;

  Bill({
    required this.id,
    required this.customerName,
    required this.timestamp,
    required this.items,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.total);
}