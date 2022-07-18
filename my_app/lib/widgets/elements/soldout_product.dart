import 'package:flutter/material.dart';
import 'package:my_app/models/group_type.dart';
import 'package:my_app/models/product.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class SoldOutProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    final product = Provider.of<Product>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Card(
      elevation: 0,
      color: const Color(0xffFDC055),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        height: 50,
        width: 200,
        child: Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                products.moveProductFromListToList(
                    product.id, GroupType.soldOut, GroupType.wanted, auth.name);
              },
              icon: const Icon(Icons.add_shopping_cart),
            ),
            IconButton(
              onPressed: () {
                products.moveProductFromListToList(product.id,
                    GroupType.soldOut, GroupType.alreadyBought, auth.name);
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
