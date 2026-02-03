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
                  return [
                    '${index + 1}',
                    item['users']?['name'] ?? 'User',
                    item['alat']?['nama_alat'] ?? 'Alat Tidak Diketahui',
                    item['tanggal_pinjam'] != null
                        ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(DateTime.parse(item['tanggal_pinjam']))
                        : '-',
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
