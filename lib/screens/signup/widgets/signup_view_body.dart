import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/common/widgets/custom_progress.dart';
import 'package:parse_with_mvvm/common/widgets/show_dialog.dart';
import 'package:parse_with_mvvm/models/parse_user_model.dart';
import 'package:parse_with_mvvm/screens/login/login_view.dart';
import 'package:parse_with_mvvm/screens/signup/signup_viewmodel.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class SignUpViewBody extends StatelessWidget {
  final SignUpViewModel viewModel;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();

  SignUpViewBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //name textfield
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "User Name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter username";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                //email textfield
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email address";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                //password textfield
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                //age textfield
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Age",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your age";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                //profession textfield
                TextFormField(
                  controller: _professionController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Profession",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your profession";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(
                  height: 32,
                ),

                //submit form btn
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        //progress
                        CustomProgress progress = CustomProgress(context);
                        progress.buildProgress();
                        await progress.startProgress();
                        //user create work
                        ParseUserModel userModel = ParseUserModel();
                        userModel.username = _nameController.text.toString();
                        userModel.emailAddress =
                            _emailController.text.toString();
                        userModel.password =
                            _passwordController.text.toString();
                        userModel.age =
                            int.parse(_ageController.text.toString());
                        userModel.profession =
                            _professionController.text.toString();
                        ParseResponse response =
                            await viewModel.createUser(userModel);
                        if (response.success) {
                          //stop progress
                          await progress.stopProgress();
                          showDialogWith(
                              context: context,
                              content: const Center(
                                child: Text(
                                    "Account was successfully created. Please verify your e-mail before login."),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.popAndPushNamed(
                                          context, LoginView.routeName);
                                    },
                                    child: const Text("Ok")),
                              ]);
                        } else {
                          //stop progress
                          await progress.stopProgress();
                          showDialogWith(
                              context: context,
                              content: Center(
                                child: Text(response.error!.message),
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
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
