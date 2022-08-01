import 'package:flutter/material.dart';
import 'package:parse_with_mvvm/common/widgets/custom_appbar.dart';
import 'package:parse_with_mvvm/models/parse_user_model.dart';
import 'package:parse_with_mvvm/screens/signup/signup_viewmodel.dart';
import 'package:parse_with_mvvm/screens/signup/widgets/signup_view_body.dart';
import 'package:parse_with_mvvm/screens/view.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  static const routeName = '/signUp';

  @override
  Widget build(BuildContext context) {
    return View(
        builder: (_, viewmodel, __) {
          return Scaffold(
            appBar: const CustomAppbar(
              automaticallyImplyLeading: true,
            ),
            body: SignUpViewBody(viewModel: viewmodel),
          );
        },
        viewmodel: SignUpViewModel());
  }
}
