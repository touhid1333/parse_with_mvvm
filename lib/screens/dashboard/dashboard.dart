import 'package:flutter/material.dart';
import 'package:parse_with_mvvm/common/widgets/custom_appbar.dart';
import 'package:parse_with_mvvm/common/widgets/custom_progress.dart';
import 'package:parse_with_mvvm/common/widgets/show_dialog.dart';
import 'package:parse_with_mvvm/screens/dashboard/dashboard_viewmodel.dart';
import 'package:parse_with_mvvm/screens/dashboard/widgets/dashboard_body.dart';
import 'package:parse_with_mvvm/screens/login/login_view.dart';
import 'package:parse_with_mvvm/screens/view.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return View(
        builder: (_, viewmodel, __) {
          //check user session
          checkUserSession(context, viewmodel);
          //return widget
          return Scaffold(
            appBar: CustomAppbar(
              automaticallyImplyLeading: true,
              actions: [
                TextButton(
                    onPressed: () async {
                      //logout work
                      CustomProgress progress = CustomProgress(context);
                      progress.buildProgress();
                      await progress.startProgress();
                      bool isLoggedOut = await viewmodel.userLogout();
                      if (isLoggedOut) {
                        await progress.stopProgress();
                        Navigator.pushNamed(context, LoginView.routeName);
                      } else {
                        //show error dialog
                        await progress.stopProgress();
                        showDialogWith(
                            context: context,
                            content: const Center(
                              child: Text(
                                  "Logout failed. Please try again later."),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Ok")),
                            ]);
                      }
                    },
                    child: const Text("Logout")),
              ],
            ),
            body: DashboardBody(viewmodel: viewmodel),
          );
        },
        viewmodel: DashboardViewModel());
  }

  //check user session method
  void checkUserSession(
      BuildContext context, DashboardViewModel viewmodel) async {
    bool isLogged = await viewmodel.checkUserSession();
    if (isLogged) {
      viewmodel.currentUser = await viewmodel.getCurrentUser();
    } else {
      showDialogWith(
          context: context,
          content: const Center(
            child: Text("Please login again."),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, LoginView.routeName);
                },
                child: const Text("Ok")),
          ]);
    }
  }
}
