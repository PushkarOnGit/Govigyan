class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  factory Product.fromMap(String id, Map<String, dynamic> data) => Product(
    id: id,
    name: data['name'] as String,
    price: (data['price'] as num).toDouble(),
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
  };
}