import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:parse_with_mvvm/common/services/custom_methods.dart';
import 'package:parse_with_mvvm/common/widgets/custom_appbar.dart';
import 'package:parse_with_mvvm/screens/login/login_view_model.dart';
import 'package:parse_with_mvvm/screens/login/widgets/login_view_body.dart';
import 'package:parse_with_mvvm/screens/view.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  //route name
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    //check notification permission
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Notification Alert"),
            content: const Text("Receive Notifications"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    AwesomeNotifications()
                        .requestPermissionToSendNotifications()
                        .then((_) => Navigator.pop(context));
                  },
                  child: const Text("Yes")),
            ],
          ),
        );
      }
    });

    return View(
        builder: (_, viewmodel, __) {
          return Scaffold(
            appBar: const CustomAppbar(
              automaticallyImplyLeading: true,
            ),
            body: LoginViewBody(viewmodel: viewmodel),
          );
        },
        viewmodel: LoginViewmodel());
  }
}
