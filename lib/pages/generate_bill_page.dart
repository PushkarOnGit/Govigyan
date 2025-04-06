import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/bill.dart';
import '../models/product.dart';
import '../utils/constants.dart';

class GenerateBillPage extends StatefulWidget {
  @override
  _GenerateBillPageState createState() => _GenerateBillPageState();
}

class _GenerateBillPageState extends State<GenerateBillPage> {
  String _customer = '';
  List<BillItem> _cart = [];

  @override
  Widget build(BuildContext context) {
    final fs = Provider.of<FirestoreService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Generate Bill')),
      body: Column(
        children: [
          // Letterhead
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(storeName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(storeAddress),
                Text('Phone: $storePhone, Pincode: $storePincode'),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  onChanged: (v) => _customer = v,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: fs.productsStream(),
              builder: (context, snap) {
                if (!snap.hasData) return Center(child: CircularProgressIndicator());
                final products = snap.data!;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (ctx, i) {
                    final p = products[i];
                    final inCart = _cart.firstWhere(
                            (e) => e.productId == p.id,
                        orElse: () => BillItem(productId: '', name: '', price: 0));
                    final qty = inCart.productId.isEmpty ? 0 : inCart.quantity;
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text('₹${p.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: qty > 0
                                ? () => setState(() {
                              inCart.quantity--;
                              if (inCart.quantity == 0)
                                _cart.removeWhere(
                                        (e) => e.productId == p.id);
                            })
                                : null,
                          ),
                          Text('$qty'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => setState(() {
                              if (qty == 0)
                                _cart.add(BillItem(
                                    productId: p.id,
                                    name: p.name,
                                    price: p.price));
                              else
                                inCart.quantity++;
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _customer.isEmpty || _cart.isEmpty
                  ? null
                  : () async {
                await fs.createBill(_customer, _cart);
                setState(() {
                  _customer = '';
                  _cart.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bill generated')));
              },
              child: Text('Generate Bill'),
            ),
          ),
        ],
      ),
    );
  }
}