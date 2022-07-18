import 'package:flutter/material.dart';
import 'package:my_app/models/product.dart';
import 'package:my_app/widgets/elements/wanted_product.dart';
import 'package:provider/provider.dart';

import '../../providers/products_provider.dart';

class ProductsList extends StatefulWidget {
  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);

    return Expanded(
      child: products.itemsWanted.isEmpty
          ? const Center(
              child: Text(
                "No products to buy",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            )
          : ReorderableListView(
              buildDefaultDragHandles: false,
              onReorder: (int oldIndex, int newIndex) {
                products.changePosition(oldIndex, newIndex);
              },
              proxyDecorator: (widget, index, animation) {
                return widget;
              },
              children: products.itemsWanted.asMap().entries.map(
                (item) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: const Card(
                      color: Color(0xffF07B3F),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.delete_outline),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      products.deleteProductFromList(
                          item.value.group, item.value.index.toString());
                    },
                    child: Container(
                      color: Color(0x00000000),
                      width: double.infinity,
                      child: ChangeNotifierProvider.value(
                        key: Key('${item.key}'),
                        value: products.itemsWanted[item.key],
                        child: WantedProduct(),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
    );
  }
}
