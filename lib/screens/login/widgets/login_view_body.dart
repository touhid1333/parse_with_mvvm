import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/common/widgets/custom_progress.dart';
import 'package:parse_with_mvvm/common/widgets/show_dialog.dart';
import 'package:parse_with_mvvm/models/parse_user_model.dart';
import 'package:parse_with_mvvm/screens/dashboard/dashboard.dart';
import 'package:parse_with_mvvm/screens/login/login_view_model.dart';
import 'package:parse_with_mvvm/screens/signup/signup_view.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class LoginViewBody extends StatelessWidget {
  final LoginViewmodel viewmodel;

  LoginViewBody({super.key, required this.viewmodel});

  //controllers
  final _formKeyLogin = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKeyLogin,
          child: Column(
            children: [
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  hintText: "User Name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide your user name";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide your password.";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKeyLogin.currentState!.validate()) {
                        //progress
                        CustomProgress progress = CustomProgress(context);
                        progress.buildProgress();
                        await progress.startProgress();
                        //user work
                        ParseUserModel userModel = ParseUserModel();
                        userModel.username = _userController.text;
                        userModel.password = _passwordController.text;
                        ParseResponse loginResponse =
                            await viewmodel.userLogin(userModel);
                        if (loginResponse.success) {
                          //stop progress
                          await progress.stopProgress();
                          showDialogWith(
                              context: context,
                              content: const Center(
                                child: Text("Logged in successfully."),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.popAndPushNamed(
                                          context, Dashboard.routeName);
                                    },
                                    child: const Text("Ok")),
                              ]);
                        } else {
                          //stop progress
                          await progress.stopProgress();
                          showDialogWith(
                              context: context,
                              content: Center(
                                child: Text(loginResponse.error!.message),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok")),
                              ]);
                        }
                      }
                    },
                    child: const Center(
                      child: Text("Login"),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpView.routeName);
                    },
                    child: const Center(
                      child: Text("Create Account"),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
