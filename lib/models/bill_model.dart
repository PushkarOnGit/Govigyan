import 'package:hive/hive.dart';

part 'bill_model.g.dart';

@HiveType(typeId: 1)
class BillItem {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final String itemName;

  @HiveField(2)
  final double itemPrice;

  @HiveField(3)
  final int quantity;

  BillItem({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.quantity,
  });

  double get total => itemPrice * quantity;
}

@HiveType(typeId: 2)
class Bill {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String customerName;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final List<BillItem> items;

  @HiveField(4)
  final String filePath;

  Bill({
    required this.id,
    required this.customerName,
    required this.dateTime,
    required this.items,
    required this.filePath,
  });

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + item.total);
  }
}