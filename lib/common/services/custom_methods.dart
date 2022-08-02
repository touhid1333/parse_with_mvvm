import 'package:intl/intl.dart';

int createUID() {
  return DateTime.now().microsecondsSinceEpoch.remainder(1000);
}
