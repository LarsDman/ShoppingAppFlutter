import 'package:flutter/material.dart';
import 'package:my_app/AppDrawer.dart';
import 'package:my_app/providers/products_provider.dart';
import 'package:my_app/screens/add_product_screen.dart';
import 'package:my_app/widgets/lists/soldout_products_list.dart';
import 'package:my_app/widgets/lists/products_list.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatefulWidget {
  static const routeName = '/overview';
  @override
  State<OverviewScreen> createState() => OverviewScreenState();
}

class OverviewScreenState extends State<OverviewScreen> {
  void addNewProduct() {
    Navigator.of(context).pushNamed(AddProductScreen.routeName);
  }

  void updateProducts() {
    Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
  }

  @override
  void initState() {
    Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: Colors.red,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: updateProducts,
            icon: const Icon(Icons.sync_rounded),
          ),
          IconButton(
            onPressed: addNewProduct,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        splashColor: Colors.red,
        elevation: 0,
        onPressed: addNewProduct,
        child: const Icon(Icons.add),
      ),
      body: Container(
        color: const Color(0xffFCA914),
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            ProductsList(),
            SoldOutProductsList(),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
