import 'package:flutter/material.dart';
import 'package:parse_with_mvvm/common/widgets/custom_appbar.dart';
import 'package:parse_with_mvvm/screens/dashboard/dashboard.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  static const routeName = '/404';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      restorationId: 'passwordDetails',
      appBar: const CustomAppbar(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '404',
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Not found what you are looking for.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
              },
              child: const Text(
                'Back to Home',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
