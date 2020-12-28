import 'package:intl/intl.dart';

class DateTimeHelper {
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String _formattedDate = formatter.format(now);

  String get formattedDate => _formattedDate;
}