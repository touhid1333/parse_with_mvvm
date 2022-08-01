import 'package:flutter/material.dart';
import 'package:parse_with_mvvm/screens/dashboard/dashboard.dart';

class CustomDrawar extends StatelessWidget {
  const CustomDrawar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String routeName = ModalRoute.of(context)!.settings.name!;
    return Drawer(
      child: Column(
        children: [
          // TODO: ADD required drawar list items
          DrawerHeader(
            child: Image.asset(
              'assets/images/png/rrad_logo.png',
              height: 100,
              width: 100,
            ),
          ),
          _buildListTile(
            context: context,
            title: 'Home',
            selected: routeName == Dashboard.routeName,
            icon: const Icon(Icons.home),
          ),
          _buildListTile(
            context: context,
            title: 'Tutorial',
            icon: const Icon(
              Icons.contact_support_outlined,
            ),
          ),
          _buildListTile(
            context: context,
            title: 'Setting',
            icon: const Icon(
              Icons.settings,
            ),
          ),
          _buildListTile(
            context: context,
            title: 'About',
            icon: const Icon(
              Icons.supervised_user_circle_outlined,
            ),
          ),
          Expanded(child: Container()),
          const Divider(),
          _buildListTile(
            context: context,
            onTap: () async {
              Navigator.of(context).pop();
            },
            title: 'Logout',
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  Container _buildListTile({
    required BuildContext context,
    required String title,
    Color? color,
    Function()? onTap,
    String? navigateTo,
    bool selected = false,
    required Widget icon,
  }) {
    // TODO: ADD Custom designe for drawar list items
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        style: ListTileStyle.list,
        onTap: onTap ??
            () {
              if (navigateTo != null)
                Navigator.of(context).pushNamed(navigateTo);
            },
        selected: selected,
        tileColor: color ?? Colors.grey.withOpacity(0.2),
        selectedColor: Theme.of(context).colorScheme.onPrimary,
        selectedTileColor: Theme.of(context).colorScheme.primary,
        leading: icon,
        title: Text(title),
      ),
    );
  }
}
