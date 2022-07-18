import 'package:flutter/material.dart';
import 'package:my_app/AppDrawer.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Stay logged in"),
            subtitle: const Text("Yes or no"),
            value: auth.autologin,
            onChanged: (bool value) {
              auth.changeAutoLogin(value);
            },
          ),
          ListTile(
            title: const Text("Delete recommendations"),
            trailing: const Icon(Icons.delete_outline),
            onTap: () {
              products.clearRecommendations();
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
