import 'package:flutter/material.dart';
import 'package:task_management/views/settings_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Yashrajsinh"),
            accountEmail: null,
            currentAccountPicture: Icon(
              Icons.person,
              size: 42,
              color: Colors.white,
            ),
          ),
          ListTile(
            title: const Text("Settings"),
            leading: const Icon(Icons.settings),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
          ),
          /*ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () {},
          ),*/
        ],
      ),
    );
  }
}
