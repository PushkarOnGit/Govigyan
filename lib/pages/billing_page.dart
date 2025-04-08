import 'package:flutter/material.dart';
import 'package:govigyan/models/bill_model.dart';
import 'package:govigyan/models/item_model.dart';
import 'package:govigyan/services/pdf_service.dart';
import 'package:govigyan/widgets/bill_item_card.dart';
import 'package:govigyan/widgets/total_price_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final _customerNameController = TextEditingController();
  final Map<String, int> _selectedItems = {};
  double _totalPrice = 0.0;

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  void _updateTotalPrice() {
    final itemsBox = Hive.box<Item>('items');
    double total = 0.0;

    _selectedItems.forEach((itemId, quantity) {
      final item = itemsBox.get(itemId);
      if (item != null) {
        total += item.price * quantity;
      }
    });

    setState(() {
      _totalPrice = total;
    });
  }

  void _updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      _selectedItems.remove(itemId);
    } else {
      _selectedItems[itemId] = quantity;
    }
    _updateTotalPrice();
  }

  Future<void> _generateBill() async {
    if (_customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter customer name')),
      );
      return;
    }

    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    final itemsBox = Hive.box<Item>('items');
    final billsBox = Hive.box<Bill>('bills');
    final now = DateTime.now();

    // Prepare bill items
    final billItems = _selectedItems.entries.map((entry) {
      final item = itemsBox.get(entry.key)!;
      return BillItem(
        itemId: item.id,
        itemName: item.name,
        itemPrice: item.price,
        quantity: entry.value,
      );
    }).toList();

    // Generate PDF
    final pdfFile = await PdfService.generateBill(
      customerName: _customerNameController.text,
      dateTime: now,
      items: billItems,
      totalAmount: _totalPrice,
    );

    // Save bill to Hive
    final bill = Bill(
      id: now.millisecondsSinceEpoch.toString(),
      customerName: _customerNameController.text,
      dateTime: now,
      items: billItems,
      filePath: pdfFile.path,
    );

    await billsBox.put(bill.id, bill);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bill generated: ${pdfFile.path}')),
    );

    // Reset form
    setState(() {
      _customerNameController.clear();
      _selectedItems.clear();
      _totalPrice = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Item>('items').listenable(),
                builder: (context, Box<Item> box, _) {
                  final items = box.values.toList();

                  if (items.isEmpty) {
                    return const Center(
                      child: Text('No items available. Add items first.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final quantity = _selectedItems[item.id] ?? 0;

                      return BillItemCard(
                        item: item,
                        quantity: quantity,
                        onQuantityChanged: (newQuantity) {
                          _updateQuantity(item.id, newQuantity);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            TotalPriceWidget(totalPrice: _totalPrice),
            ElevatedButton(
              onPressed: _generateBill,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Generate Bill'),
            ),
          ],
        ),
      ),
    );
  }
}