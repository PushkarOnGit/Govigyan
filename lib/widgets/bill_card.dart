import 'package:flutter/material.dart';
import '../models/bill.dart';
import 'package:intl/intl.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  const BillCard({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_jm();
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(bill.customerName),
        subtitle: Text(df.format(bill.timestamp)),
        trailing: Text('₹${bill.totalAmount.toStringAsFixed(2)}'),
        onTap: () {
          // Optionally show detailed items
        },
      ),
    );
  }
}