import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final List<Widget>? actions;
  const CustomAppbar({
    Key? key,
    this.automaticallyImplyLeading = false,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Parse with MVVM",
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: automaticallyImplyLeading == true ? null : leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
    );
  }
}
