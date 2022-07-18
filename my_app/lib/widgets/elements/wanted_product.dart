import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/models/group_type.dart';
import 'package:my_app/models/product.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/products_provider.dart';

class WantedProduct extends StatelessWidget {
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
            Column(
              children: [
                const Divider(height: 7),
                Text(product.userId),
                Text(product.renderTime()),
              ],
            ),
            IconButton(
              onPressed: () {
                products.moveProductFromListToList(product.id, GroupType.wanted,
                    GroupType.alreadyBought, auth.name);
              },
              icon: const Icon(
                Icons.add_box_outlined,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                products.moveProductFromListToList(
                    product.id, GroupType.wanted, GroupType.soldOut, auth.name);
              },
              icon: const Icon(
                Icons.block,
                color: Colors.black,
              ),
            ),
            ReorderableDragStartListener(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notes_rounded),
              ),
              index: products.itemsWanted.indexOf(product),
            ),
          ],
        ),
      ),
    );
  }
}
