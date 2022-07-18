import 'package:flutter/material.dart';
import 'package:my_app/models/group_type.dart';
import 'package:my_app/providers/products_provider.dart';
import 'package:my_app/widgets/elements/soldout_product.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/auth_provider.dart';

class SoldOutProductsList extends StatefulWidget {
  @override
  State<SoldOutProductsList> createState() => _SoldOutProductsListState();
}

class _SoldOutProductsListState extends State<SoldOutProductsList> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final list = products.itemsSoldOut;

    const soldOutText = Text(
      "Sold out products",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    );

    return products.itemsSoldOut.isEmpty
        ? Column(
            children: const [
              soldOutText,
              Center(
                child: Text(
                  "No sold out products",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
              )
            ],
          )
        : Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            "Sold out products",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: ((context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Color(0xffF07B3F),
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(Icons.delete_outline),
                            ),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ChangeNotifierProvider.value(
                            value: list[index],
                            child: SoldOutProduct(),
                          ),
                        ),
                        onDismissed: (direction) {
                          products.moveProductFromListToList(
                              list[index].id,
                              GroupType.soldOut,
                              GroupType.alreadyBought,
                              auth.name);
                          // products.deleteProductFromList(
                          //     GroupType.soldOut, list[index].id);
                          // Then show a snackbar.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('dismissed'),
                            ),
                          );
                        },
                      );
                    }),
                    itemCount: list.length,
                  ),
                ),
              ],
            ),
          );
  }
}
