import 'package:flutter/material.dart';
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
