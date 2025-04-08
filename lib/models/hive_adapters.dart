import 'package:govigyan/models/bill_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:govigyan/models/item_model.dart';

void registerHiveAdapters() {
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(BillAdapter());
  Hive.registerAdapter(BillItemAdapter());
}