import 'package:flutter/material.dart';
import 'package:govigyan/models/bill_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class PreviousBillsPage extends StatelessWidget {
  const PreviousBillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Bills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BillsSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Bill>('bills').listenable(),
        builder: (context, Box<Bill> box, _) {
          final bills = box.values.toList()
            ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

          if (bills.isEmpty) {
            return const Center(
              child: Text('No bills generated yet.'),
            );
          }

          return ListView.builder(
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final bill = bills[index];
              return ListTile(
                title: Text(bill.customerName),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(bill.dateTime),
                ),
                trailing: Text(
                  'Rs. ${bill.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onTap: () => OpenFile.open(bill.filePath),
              );
            },
          );
        },
      ),
    );
  }
}

class BillsSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final billsBox = Hive.box<Bill>('bills');
    final bills = billsBox.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final filteredBills = query.isEmpty
        ? bills
        : bills.where((bill) =>
    bill.customerName.toLowerCase().contains(query.toLowerCase()) ||
        DateFormat('yyyy-MM-dd').format(bill.dateTime)
            .toLowerCase()
            .contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: filteredBills.length,
      itemBuilder: (context, index) {
        final bill = filteredBills[index];
        return ListTile(
          title: Text(bill.customerName),
          subtitle: Text(
            DateFormat('yyyy-MM-dd HH:mm').format(bill.dateTime),
          ),
          trailing: Text(
            'Rs. ${bill.totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () => OpenFile.open(bill.filePath),
        );
      },
    );
  }
}