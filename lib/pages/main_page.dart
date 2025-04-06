import 'package:flutter/material.dart';
import 'previous_bills_page.dart';
import 'generate_bill_page.dart';
import 'add_item_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final _pages = [
    PreviousBillsPage(),
    GenerateBillPage(),
    AddItemPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Bills'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart), label: 'Generate'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), label: 'Add Item'),
        ],
      ),
    );
  }
}