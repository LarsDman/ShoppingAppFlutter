import 'package:flutter/material.dart';
import 'package:my_app/models/group_type.dart';
import 'package:my_app/models/product.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../providers/products_provider.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<AddProductScreen> createState() => _AddProductScreen_State();
}

class _AddProductScreen_State extends State<AddProductScreen> {
  late TextEditingController controller;

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
      print("Compare: " + product.title + " with: " + value);
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

    print("inWanted: " + inWanted.toString());
    print("inSoldOut: " + inSoldOut.toString());
    print("inBought: " + inBought.toString());

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
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xffFCA914),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Autocomplete<Product>(
                  optionsBuilder: (textEditingValue) {
                    List<Product> allProducts = products.itemsAlreadyBought;
                    List<Product> allOptions =
                        allProducts.where((Product option) {
                      return option.title
                          .contains(textEditingValue.text.toLowerCase());
                    }).toList();
                    allOptions.sort((Product a, Product b) {
                      return a.title
                          .toLowerCase()
                          .compareTo(b.title.toLowerCase());
                    });
                    bool cut = false;
                    if (allOptions.length >= 5) {
                      cut = true;
                    }
                    if (cut) {
                      return allOptions.sublist(0, 5);
                    } else {
                      return allOptions;
                    }
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        child: SizedBox(
                          width: constraints.biggest.width,
                          height: options.length * 35,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final Product option = options.elementAt(index);
                              return Container(
                                height: 35,
                                color: index % 2 == 1
                                    ? const Color(0xffFDC055)
                                    : Color.fromARGB(255, 231, 154, 22),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 0, 0),
                                              child: SubstringHighlight(
                                                text: option.title,
                                                term: controller.text,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: SizedBox(
                                              height: 35,
                                              width: 35,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  checkListsWithObject(
                                                    option.title,
                                                    context,
                                                    true,
                                                    null,
                                                  );
                                                },
                                                icon: const Icon(Icons.add,
                                                    size: 25.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: options.length,
                          ),
                        ),
                      ),
                    );
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    controller = textEditingController;
                    return Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Color(0xffFDC055),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              focusNode: focusNode,
                              onSubmitted: (value) {
                                checkListsWithObject(
                                    value, context, false, null);
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              checkListsWithObject(
                                  controller.text, context, false, null);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
          // Autocomplete<Product>(
          //   optionsBuilder: (TextEditingValue textEditingValue) {
          //     List<Product> allProducts = products.itemsAlreadyBought;
          //     List<Product> allOptions = allProducts.where((Product option) {
          //       return option.title
          //           .contains(textEditingValue.text.toLowerCase());
          //     }).toList();
          //     bool cut = false;
          //     if (allOptions.length >= 5) {
          //       cut = true;
          //     }
          //     if (cut) {
          //       return allOptions.sublist(0, 5);
          //     } else {
          //       return allOptions;
          //     }
          //   },
          //   optionsViewBuilder: (context, onSelected, options) {
          //     return Material(
          //       shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.only(
          //             bottomLeft: Radius.circular(15),
          //             bottomRight: Radius.circular(15)),
          //       ),
          //       color: Colors.grey,
          //       child: ListView.separated(
          //           itemBuilder: (BuildContext context, int index) {
          //             final Product option = options.elementAt(index);
          //             print(index);
          //             return ListTile(
          //               tileColor: Colors.green,
          //               title: Text(option.title),
          //             );
          //           },
          //           separatorBuilder: (context, index) => const Divider(),
          //           itemCount: options.length),
          //       child: SizedBox(
          //         width: constraints.biggest.width,
          //         height: options.length * 40,
          //         child: ListView.builder(
          //           itemCount: options.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             final Product option = options.elementAt(index);
          //             return Container(
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                     child: Padding(
          //                       padding:
          //                           const EdgeInsets.fromLTRB(10, 0, 0, 0),
          //                       child: Text(
          //                         option.title,
          //                         style: const TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             color: Colors.black,
          //                             fontSize: 18),
          //                       ),
          //                     ),
          //                   ),
          //                   IconButton(
          //                     icon: const Icon(Icons.add),
          //                     onPressed: () {
          //                       onSelected(option);
          //                       products.moveProductFromListToList(
          //                           option.id,
          //                           GroupType.alreadyBought,
          //                           GroupType.wanted,
          //                           auth.name);
          //                       Navigator.pop(context);
          //                     },
          //                   ),
          //                 ],
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //     );
          //   },
          //   fieldViewBuilder: (context, textEditingController, focusNode,
          //       onFieldSubmitted) {
          //     return const Card(
          //       elevation: 0,
          //       color: Color(0xffFDC055),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(15),
          //           topRight: Radius.circular(15),
          //         ),
          //       ),
          //       child: TextField(),
          //     );
          //   },
          // ),