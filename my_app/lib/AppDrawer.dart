import 'package:flutter/material.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/overview_screen.dart';
import 'package:my_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text("Hello " + auth.name + "!"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red,
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Shop"),
          onTap: () {
            print("isAuth " + auth.isAuth.toString());
            Navigator.of(context).pushReplacementNamed("/");
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Settings"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(SettingsScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () {
            Navigator.of(context).pop();
            Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ]),
    );
  }
}
