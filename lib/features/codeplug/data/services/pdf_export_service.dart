import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/models.dart';

/// Service for exporting codeplug to PDF
class PdfExportService {
  /// Generate and display PDF preview/print dialog
  Future<void> exportToPdf(Codeplug codeplug) async {
    final pdf = pw.Document();

    // Title page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                codeplug.name,
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                codeplug.radioModel,
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey),
              ),
            ),
            pw.SizedBox(height: 32),
            pw.Divider(),
            pw.SizedBox(height: 16),
            _buildSummarySection(codeplug),
            pw.SizedBox(height: 24),
            _buildSettingsSection(codeplug.settings),
          ],
        ),
      ),
    );

    // Channels pages
    if (codeplug.channels.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (context) => pw.Text(
            'Channels (${codeplug.channels.length})',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          build: (context) => [
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellPadding: const pw.EdgeInsets.all(4),
              headers: ['Name', 'RX (MHz)', 'TX (MHz)', 'Mode', 'TS', 'CC'],
              data: codeplug.channels
                  .map((c) => [
                        c.name,
                        c.rxFrequency.toStringAsFixed(4),
                        c.txFrequency.toStringAsFixed(4),
                        c.mode == ChannelMode.digital ? 'DMR' : 'FM',
                        c.mode == ChannelMode.digital ? c.timeslot.toString() : '-',
                        c.mode == ChannelMode.digital ? c.colorCode.toString() : '-',
                      ])
                  .toList(),
            ),
          ],
        ),
      );
    }

    // Zones pages
    if (codeplug.zones.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (context) => pw.Text(
            'Zones (${codeplug.zones.length})',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          build: (context) => codeplug.zones
              .map((zone) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 16),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          zone.name,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '${zone.channelIds.length} channels',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          _getZoneChannelNames(zone, codeplug.channels),
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
    }

    // Contacts pages
    if (codeplug.contacts.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (context) => pw.Text(
            'Contacts (${codeplug.contacts.length})',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          build: (context) => [
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellPadding: const pw.EdgeInsets.all(4),
              headers: ['Name', 'DMR ID', 'Type'],
              data: codeplug.contacts
                  .map((c) => [
                        c.name,
                        c.dmrId.toString(),
                        c.callType.name.toUpperCase(),
                      ])
                  .toList(),
            ),
          ],
        ),
      );
    }

    // Show print/save dialog
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: '${codeplug.name}.pdf',
    );
  }

  pw.Widget _buildSummarySection(Codeplug codeplug) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatBox('Channels', codeplug.channels.length.toString()),
              _buildStatBox('Zones', codeplug.zones.length.toString()),
              _buildStatBox('Contacts', codeplug.contacts.length.toString()),
            ],
          ),
        ],
      );

  pw.Widget _buildStatBox(String label, String value) => pw.Container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          children: [
            pw.Text(
              value,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
          ],
        ),
      );

  pw.Widget _buildSettingsSection(RadioSettings settings) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Identity',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Text('DMR ID: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(settings.dmrId == 0 ? '-' : settings.dmrId.toString()),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              pw.Text('Callsign: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(settings.callsign.isEmpty ? '-' : settings.callsign),
            ],
          ),
        ],
      );

  String _getZoneChannelNames(Zone zone, List<Channel> allChannels) {
    final channelMap = {for (final c in allChannels) c.id: c.name};
    final names = zone.channelIds
        .map((id) => channelMap[id] ?? 'Unknown')
        .take(10)
        .toList();
    final suffix = zone.channelIds.length > 10
        ? ', ... (+${zone.channelIds.length - 10} more)'
        : '';
    return names.join(', ') + suffix;
  }
}
