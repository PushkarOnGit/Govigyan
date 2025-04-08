import 'package:hive/hive.dart';

part 'item_model.g.dart';

@HiveType(typeId: 0)
class Item {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  Item({
    required this.id,
    required this.name,
    required this.price,
  });
}