import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ReportScreen {
  static Future<void> generateReport(
    BuildContext context,
    List<Map<String, dynamic>> data,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Laporan Peminjaman',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: [
                  'No',
                  'Nama User',
                  'Nama Alat',
                  'Tanggal Pinjam',
                  'Status',
                ],
data: List.generate(data.length, (index) {
  final item = data[index];
  
  String formattedDate = '-';
  final rawDate = item['tanggal_pinjam'];

  if (rawDate != null && rawDate.toString().isNotEmpty) {
    try {
      final dateTime = DateTime.parse(rawDate.toString());
      formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      formattedDate = rawDate.toString();
    }
  }

  return [
    '${index + 1}',
    item['user_name']?.toString() ?? '-',      
    item['alat_name']?.toString() ?? '-',     
    formattedDate, 
    item['status_peminjaman']?.toString().toUpperCase() ?? '-',
  ];
}),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
