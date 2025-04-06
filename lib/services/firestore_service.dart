import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/bill.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // PRODUCTS
  Stream<List<Product>> productsStream() => _db
      .collection('products')
      .snapshots()
      .map((snap) => snap.docs
      .map((d) => Product.fromMap(d.id, d.data()))
      .toList());

  Future<void> addProduct(Product p) async {
    await _db.collection('products').add(p.toMap());
  }

  // BILLS
  Stream<List<Bill>> billsStream() => _db
      .collection('bills')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .asyncMap((snap) async {
    return Future.wait(snap.docs.map((doc) async {
      final data = doc.data();
      // load subcollection items
      final itemsSnap = await doc.reference.collection('items').get();
      final items = itemsSnap.docs
          .map((i) => BillItem(
        productId: i['productId'] as String,
        name: i['name'] as String,
        price: (i['price'] as num).toDouble(),
        quantity: i['quantity'] as int,
      ))
          .toList();
      return Bill(
        id: doc.id,
        customerName: data['customerName'] as String,
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        items: items,
      );
    }));
  });

  Future<void> createBill(String customerName, List<BillItem> items) async {
    final ref = await _db.collection('bills').add({
      'customerName': customerName,
      'timestamp': FieldValue.serverTimestamp(),
    });
    final batch = _db.batch();
    for (var item in items) {
      final doc = ref.collection('items').doc();
      batch.set(doc, item.toMap());
    }
    await batch.commit();
  }
}