import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StatefulWrapper extends StatefulWidget {
  final AsyncCallback onDone;
  final AsyncCallback onInit;
  final String? routeName;
  final List<String> excludedRoutes;
  final String? loginRoute;
  final Widget child;
  const StatefulWrapper({
    Key? key,
    required this.onInit,
    required this.onDone,
    required this.child,
    required this.routeName,
    this.excludedRoutes = const [],
    this.loginRoute = '/login',
  }) : super(key: key);

  @override
  State<StatefulWrapper> createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    super.initState();

    if ((widget.excludedRoutes.isNotEmpty &&
            !widget.excludedRoutes.contains(widget.routeName) ||
        widget.routeName != widget.loginRoute)) {
      hasUserLogged().then((value) {
        if (value == true) {
          widget.onInit.call().then((value) async {
            await widget.onDone.call();
          });
        } else {
          if (widget.loginRoute != null) {
            Navigator.of(context).pushReplacementNamed(widget.loginRoute!);
          } else {
            debugPrint('Please add login route');
          }
        }
      });
    } else {
      widget.onInit.call().then((value) async {
        await widget.onDone.call();
      });
    }
  }

  Future<bool> hasUserLogged() async {
    bool hasUserLogged = false;
    // TODO: implement Login check
    // hasUserLogged = await dependency<LoginService>().hasUserLogged();
    return hasUserLogged;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
