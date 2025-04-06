import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../widgets/bill_card.dart';

class PreviousBillsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fs = Provider.of<FirestoreService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Previous Bills')),
      body: StreamBuilder(
        stream: fs.billsStream(),
        builder: (context, AsyncSnapshot<List<Bill>> snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          final bills = snap.data!;
          if (bills.isEmpty) return Center(child: Text('No bills yet'));
          return ListView(
            children: bills.map((b) => BillCard(bill: b)).toList(),
          );
        },
      ),
    );
  }
}