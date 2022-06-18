import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:vdsadmin/invoice/pdf_api.dart';
import 'package:vdsadmin/models/customer.dart';
import 'package:vdsadmin/models/invoice.dart';
import 'package:vdsadmin/models/suppiler.dart';
import 'package:vdsadmin/models/utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    final fontData = await rootBundle.load("fonts/Poppins-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final fontData2 = await rootBundle.load("fonts/Poppins-Bold.ttf");
    final ttf2 = pw.Font.ttf(fontData);
    final fontData3 = await rootBundle.load("fonts/Hind-Bold.ttf");
    final ttf3 = pw.Font.ttf(fontData);
    final netTotal = invoice.items
        .map((item) => item.OurPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final netTotalMRP = invoice.items
        .map((item) => item.MRP * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    // final MRPPercent = invoice.items.first.MRP;
    // final MRP = netTotal * MRPPercent;
    final total = netTotal;
    final totalMRP = netTotalMRP;
    final dicount = totalMRP - total;
    final headers = ['Description', 'Quantity', 'MRP', 'Our Price', 'Total'];
    final data = invoice.items.map((item) {
      final total = item.OurPrice * item.quantity;

      return [
        item.description,
        '${item.quantity}',
        '₹ ${item.MRP}',
        '₹ ${item.OurPrice}',
        '₹ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        // buildInvoice(invoice),
        Table.fromTextArray(
          headers: headers,
          data: data,
          border: null,
          headerStyle: TextStyle(fontWeight: FontWeight.bold),
          cellStyle: TextStyle(
            fontWeight: FontWeight.bold,
            font: ttf,
          ),
          headerDecoration: BoxDecoration(color: PdfColors.grey300),
          cellHeight: 30,
          cellAlignments: {
            0: Alignment.centerLeft,
            1: Alignment.centerRight,
            2: Alignment.centerRight,
            3: Alignment.centerRight,
            4: Alignment.centerRight,
            5: Alignment.centerLeft,
          },
        ),

        Divider(),
        // buildTotal(invoice),
        Container(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Spacer(flex: 6),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                      title: 'Net total',
                      value: '₹ ${Utils.formatPrice(netTotalMRP)}',
                      unite: true,
                      titleStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        font: ttf3,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount off',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹ ${Utils.formatPrice(dicount)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: ttf3,
                          ),
                        ),
                      ],
                    ),
                    // buildText(
                    //   title: 'Discount off',
                    //   value: Utils.formatPrice(dicount),
                    //   unite: true,
                    // ),
                    // buildText(
                    //   title: 'MRP ${MRPPercent * 100} %',
                    //   value: Utils.formatPrice(MRP),
                    //   unite: true,
                    // ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total amount ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹ ${Utils.formatPrice(total)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: ttf3,
                          ),
                        ),
                      ],
                    ),

                    // buildText(
                    //   title: 'Total amount ',
                    //   titleStyle: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    //   value: Utils.formatPrice(total),
                    //   unite: true,
                    // ),
                    SizedBox(height: 2 * PdfPageFormat.mm),
                    Container(height: 1, color: PdfColors.grey400),
                    SizedBox(height: 0.5 * PdfPageFormat.mm),
                    Container(height: 1, color: PdfColors.grey400),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.contact),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  // static Future<Widget> buildInvoice(Invoice invoice) async {
  //   final headers = ['Description', 'Quantity', 'MRP', 'Our Price', 'Total'];
  //   final fontData = await rootBundle.load("assets/open-sans.ttf");
  //   final ttf = pw.Font.ttf(fontData);
  //   final data = invoice.items.map((item) {
  //     final total = item.OurPrice * item.quantity;

  //     return [
  //       item.description,
  //       '${item.quantity}',
  //       '\$ ${item.MRP}',
  //       '\$ ${item.OurPrice}',
  //       '\$ ${total.toStringAsFixed(2)}',
  //     ];
  //   }).toList();

  //   return Table.fromTextArray(
  //     headers: headers,
  //     data: data,
  //     border: null,
  //     headerStyle: TextStyle(fontWeight: FontWeight.bold),
  //     cellStyle: TextStyle(
  //       fontWeight: FontWeight.bold,
  //     ),
  //     headerDecoration: BoxDecoration(color: PdfColors.grey300),
  //     cellHeight: 30,
  //     cellAlignments: {
  //       0: Alignment.centerLeft,
  //       1: Alignment.centerRight,
  //       2: Alignment.centerRight,
  //       3: Alignment.centerRight,
  //       4: Alignment.centerRight,
  //       5: Alignment.centerRight,
  //     },
  //   );
  // }

  // static Future<pw.Widget> buildTotal(Invoice invoice) async {
  //   final netTotal = invoice.items
  //       .map((item) => item.OurPrice * item.quantity)
  //       .reduce((item1, item2) => item1 + item2);
  //   final netTotalMRP = invoice.items
  //       .map((item) => item.MRP * item.quantity)
  //       .reduce((item1, item2) => item1 + item2);
  //   // final MRPPercent = invoice.items.first.MRP;
  //   // final MRP = netTotal * MRPPercent;
  //   final total = netTotal;
  //   final totalMRP = netTotalMRP;
  //   final dicount = totalMRP - total;

  //   final fontData = await rootBundle.load("fonts/Poppins-Regular.ttf");
  //   final ttf = pw.Font.ttf(fontData);
  //   return Container(
  //     alignment: Alignment.centerRight,
  //     child: Row(
  //       children: [
  //         Spacer(flex: 6),
  //         Expanded(
  //           flex: 4,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               buildText(
  //                 title: 'Net total',
  //                 value: Utils.formatPrice(netTotalMRP),
  //                 unite: true,
  //                 titleStyle: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   font: ttf,
  //                 ),
  //               ),
  //               buildText(
  //                 title: 'Discount off',
  //                 value: Utils.formatPrice(dicount),
  //                 unite: true,
  //               ),
  //               // buildText(
  //               //   title: 'MRP ${MRPPercent * 100} %',
  //               //   value: Utils.formatPrice(MRP),
  //               //   unite: true,
  //               // ),
  //               Divider(),
  //               buildText(
  //                 title: 'Total amount ',
  //                 titleStyle: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 value: Utils.formatPrice(total),
  //                 unite: true,
  //               ),
  //               SizedBox(height: 2 * PdfPageFormat.mm),
  //               Container(height: 1, color: PdfColors.grey400),
  //               SizedBox(height: 0.5 * PdfPageFormat.mm),
  //               Container(height: 1, color: PdfColors.grey400),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: '© Copyright', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ??
        TextStyle(
          fontWeight: FontWeight.bold,
        );

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
