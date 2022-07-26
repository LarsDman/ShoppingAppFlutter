import 'package:flutter/material.dart';
import 'package:my_app/models/group_type.dart';
import 'package:my_app/models/product.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<AddProductScreen> createState() => _AddProductScreen_State();
}

class _AddProductScreen_State extends State<AddProductScreen> {
  var inputText = "";

  @override
  void dispose() {
    super.dispose();
  }

  void _showMessage(String msg) {
    var snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void checkListsWithObject(String value, BuildContext context,
      bool usedAutocomplete, VoidCallback? onFieldSubmitted) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final products = Provider.of<ProductsProvider>(context, listen: false);
    bool inWanted = false;
    bool inSoldOut = false;
    bool inBought = false;
    for (Product product in products.itemsWanted) {
      if (product.title.toLowerCase() == value.toLowerCase()) {
        inWanted = true;
        break;
      }
    }
    for (Product product in products.itemsSoldOut) {
      if (product.title.toLowerCase() == value.toLowerCase()) {
        inSoldOut = true;
        break;
      }
    }
    for (Product product in products.itemsAlreadyBought) {
      if (product.title.toLowerCase() == value.toLowerCase()) {
        inBought = true;
        break;
      }
    }

    if (inWanted) {
      _showMessage("Product already in list.");
      if (usedAutocomplete && onFieldSubmitted != null) {
        onFieldSubmitted();
      }
      Navigator.pop(context);
    } else if (inSoldOut) {
      _showMessage("Product is sold out.");
      if (usedAutocomplete && onFieldSubmitted != null) {
        onFieldSubmitted();
      }
      Navigator.pop(context);
    } else if (inBought) {
      for (Product product in products.itemsAlreadyBought) {
        if (product.title.toLowerCase() == value.toLowerCase()) {
          inBought = true;
          products.moveProductFromListToList(
              product.id, GroupType.alreadyBought, GroupType.wanted, auth.name);
          if (usedAutocomplete && onFieldSubmitted != null) {
            onFieldSubmitted();
          }
          _showMessage("Added product.");
          Navigator.pop(context);
          break;
        }
      }
    } else {
      products.addNewProduct(value, auth.name);
      if (usedAutocomplete && onFieldSubmitted != null) {
        onFieldSubmitted();
      }
      _showMessage("Added product.");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new product"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: const Color(0xffFCA914),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(
          elevation: 0,
          color: const Color(0xffFDC055),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: RawAutocomplete(
              displayStringForOption: ((Product option) => option.title),
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<Product> onSelected,
                  Iterable<Product> options) {
                return Container(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Product option = options.elementAt(index);
                      return Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 60, 0),
                        child: Card(
                          elevation: 0,
                          color: const Color(0xffFDC055),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    option.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  onSelected(option);
                                  products.moveProductFromListToList(
                                      option.id,
                                      GroupType.alreadyBought,
                                      GroupType.wanted,
                                      auth.name);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                List<Product> allProducts = products.itemsAlreadyBought;
                return allProducts.where((Product option) {
                  return option.title
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 0,
                          child: TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            onFieldSubmitted: (String value) {
                              checkListsWithObject(
                                  value, context, true, onFieldSubmitted);
                            },
                            onChanged: (text) {
                              inputText = text;
                            },
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter a product",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18),
                              focusColor: Colors.green,
                              fillColor: Color(0xffFDC055),
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          checkListsWithObject(inputText, context, false, null);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
