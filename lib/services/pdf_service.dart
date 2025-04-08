import 'dart:io';
import 'package:govigyan/models/bill_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfService {
  static Future<File> generateBill({
    required String customerName,
    required DateTime dateTime,
    required List<BillItem> items,
    required double totalAmount,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'GOVIGYAAN - INVOICE',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Customer: $customerName'),
                      pw.Text('Date: ${DateFormat('yyyy-MM-dd').format(dateTime)}'),
                      pw.Text('Time: ${DateFormat('HH:mm').format(dateTime)}'),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
                headers: ['Item', 'Price', 'Qty', 'Total'],
                data: items.map((item) => [
                  item.itemName,
                  'Rs. ${item.itemPrice.toStringAsFixed(2)}',
                  item.quantity.toString(),
                  'Rs. ${(item.itemPrice * item.quantity).toStringAsFixed(2)}',
                ]).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total Amount: Rs. ${totalAmount.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                'Thank you for your business!',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Get directory
    final directory = await getApplicationDocumentsDirectory();
    final billsDir = Directory('${directory.path}/bills');
    if (!await billsDir.exists()) {
      await billsDir.create(recursive: true);
    }

    // Save file
    final file = File(
        '${billsDir.path}/${customerName}_${DateFormat('yyyy-MM-dd').format(dateTime)}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}