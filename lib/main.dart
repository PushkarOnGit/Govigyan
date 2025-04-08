import 'package:flutter/material.dart';
import 'package:govigyan/models/bill_model.dart';
import 'package:govigyan/models/item_model.dart';
import 'package:govigyan/pages/billing_page.dart';
import 'package:govigyan/pages/item_page.dart';
import 'package:govigyan/pages/pevious_bills_page.dart';
import 'package:govigyan/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/hive_adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  registerHiveAdapters();

  // Open boxes
  await Hive.openBox<Item>('items');
  await Hive.openBox<Bill>('bills');

  runApp(const GovigyaanApp());
}

class GovigyaanApp extends StatelessWidget {
  const GovigyaanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GOVIGYAAN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ItemsPage(),
    const BillingPage(),
    const PreviousBillsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOVIGYAAN'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Billing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Bills History',
          ),
        ],
      ),
    );
  }
}