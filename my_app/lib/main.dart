import 'package:flutter/material.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/screens/add_product_screen.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/overview_screen.dart';
import 'package:my_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import 'providers/products_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (ctx) => ProductsProvider("", [], [], []),
          update: (ctx, auth, previous) {
            return ProductsProvider(
              auth.token,
              previous == null ? [] : previous.itemsWanted,
              previous == null ? [] : previous.itemsSoldOut,
              previous == null ? [] : previous.itemsAlreadyBought,
            );
          },
        ),
        // ChangeNotifierProxyProvider<AuthProvider, UsersProvider>(
        //   create: (ctx) => UsersProvider(User("", "")),
        //   update: (ctx, auth, previous) {
        //     return UsersProvider(
        //       previous == null ? User("", "") : previous.localUser,
        //     );
        //   },
        // ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            // home: LoginScreen(),
            home: auth.isAuth
                ? OverviewScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, authResult) => LoginScreen(),
                  ),
            routes: {
              OverviewScreen.routeName: (context) => OverviewScreen(),
              AddProductScreen.routeName: (context) => AddProductScreen(),
              SettingsScreen.routeName: (context) => SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
