import 'package:vdsadmin/models/customer.dart';
import 'package:vdsadmin/models/suppiler.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  late dynamic quantity;
  final dynamic MRP;
  final dynamic OurPrice;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.OurPrice,
    required this.MRP,
  });
}
