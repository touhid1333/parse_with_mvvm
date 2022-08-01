import 'package:flutter/material.dart';

showDialogWith({
  required BuildContext context,
  String title = 'Warning',
  bool barrierDismissible = true,
  required Widget content,
  required List<Widget>? actions,
}) async {
  await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text(title),
          content: content,
          actions: actions,
        );
      });
}
