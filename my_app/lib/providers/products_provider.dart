import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_app/constants/constants.dart' as constants;
import 'package:my_app/models/group_type.dart';
import 'package:my_app/models/product.dart';
import 'package:my_app/constants/constantsLinks.dart' as constants_links;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import "package:http/http.dart" as http;
import "dart:convert";

class ProductsProvider with ChangeNotifier {
  List<Product> _itemsWanted = [
    Product(
      const Uuid().v1(),
      "apple",
      "id1",
      GroupType.wanted,
      1,
      DateTime(2022, 7, 7).toString(),
    ),
    Product(
      const Uuid().v1(),
      "banana",
      "id1",
      GroupType.wanted,
      0,
      DateTime(2022, 7, 5).toString(),
    ),
    Product(
      const Uuid().v1(),
      "mango",
      "id2",
      GroupType.wanted,
      3,
      DateTime(2022, 6, 28).toString(),
    ),
    Product(
      const Uuid().v1(),
      "potatoe",
      "id1",
      GroupType.wanted,
      2,
      DateTime(2022, 3, 2).toString(),
    ),
    Product(
      const Uuid().v1(),
      "nut",
      "id2",
      GroupType.wanted,
      4,
      DateTime(2022, 5, 23).toString(),
    ),
  ];

  List<Product> _itemsSoldOut = [
    Product(
      const Uuid().v1(),
      "berry",
      "id1",
      GroupType.soldOut,
      1,
      "",
    ),
    Product(
      const Uuid().v1(),
      "orange",
      "id2",
      GroupType.soldOut,
      2,
      "",
    ),
    Product(
      const Uuid().v1(),
      "peach",
      "id2",
      GroupType.soldOut,
      3,
      "",
    ),
    Product(
      const Uuid().v1(),
      "pumpkin",
      "id1",
      GroupType.soldOut,
      4,
      "",
    ),
    Product(
      const Uuid().v1(),
      "tomato",
      "id1",
      GroupType.soldOut,
      0,
      "",
    ),
  ];

  List<Product> _itemsAlreadyBought = [
    Product(
      const Uuid().v1(),
      "olive",
      "id2",
      GroupType.alreadyBought,
      1,
      "",
    ),
    Product(
      const Uuid().v1(),
      "pepper",
      "id2",
      GroupType.alreadyBought,
      2,
      "",
    ),
    Product(
      const Uuid().v1(),
      "melon",
      "id1",
      GroupType.alreadyBought,
      3,
      "",
    ),
    Product(
      const Uuid().v1(),
      "grapefruit",
      "id1",
      GroupType.alreadyBought,
      4,
      "",
    ),
    Product(
      const Uuid().v1(),
      "avocado",
      "id1",
      GroupType.alreadyBought,
      0,
      "",
    ),
  ];

  final String authToken;

  ProductsProvider(
    this.authToken,
    this._itemsWanted,
    this._itemsSoldOut,
    this._itemsAlreadyBought,
  );

  List<Product> get itemsWanted {
    return [..._itemsWanted];
  }

  List<Product> get itemsSoldOut {
    return [..._itemsSoldOut];
  }

  List<Product> get itemsAlreadyBought {
    return [..._itemsAlreadyBought];
  }

  Future<void> deleteProductFromList(GroupType groupType, String id) async {
    final urlWanted = Uri.parse(constants_links.urlWanted + "?auth=$authToken");
    final urlSoldOut =
        Uri.parse(constants_links.urlSoldOut + "?auth=$authToken");
    final urlBought = Uri.parse(constants_links.urlBought + "?auth=$authToken");
    if (groupType == GroupType.wanted) {
      _itemsWanted.removeWhere((element) => element.index.toString() == id);
      _updateIndexes(_itemsWanted);
      await http.put(
        urlWanted,
        body: jsonEncode(_itemsWanted),
      );
      notifyListeners();
    } else if (groupType == GroupType.soldOut) {
      _itemsSoldOut.removeWhere((element) => element.index.toString() == id);
      _updateIndexes(_itemsSoldOut);
      await http.put(
        urlSoldOut,
        body: jsonEncode(_itemsSoldOut),
      );
      notifyListeners();
    } else if (groupType == GroupType.alreadyBought) {
      _itemsAlreadyBought
          .removeWhere((element) => element.index.toString() == id);
      _updateIndexes(_itemsAlreadyBought);
      await http.put(
        urlBought,
        body: jsonEncode(_itemsAlreadyBought),
      );
      notifyListeners();
    }
  }

  void moveProductFromListToList(String id, GroupType sourceList,
      GroupType destinationList, String userId) {
    final urlBase = Uri.parse(constants_links.urlBase + "=$authToken");
    final urlWanted = Uri.parse(constants_links.urlWanted + "?auth=$authToken");
    final urlSoldOut =
        Uri.parse(constants_links.urlSoldOut + "?auth=$authToken");
    final urlBought = Uri.parse(constants_links.urlBought + "?auth=$authToken");

    bool validSourceList = false;
    bool validDestinationList = false;
    bool found = false;
    Product changeProduct = Product(
      const Uuid().v1(),
      "",
      userId,
      GroupType.wanted,
      0,
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).toString(),
    );
    List<Product> source = [];
    List<Product> destination = [];

    final Uri urlSource, urlDestination;

    if (sourceList == GroupType.wanted) {
      source = _itemsWanted;
      urlSource = urlWanted;
      validSourceList = true;
    } else if (sourceList == GroupType.soldOut) {
      source = _itemsSoldOut;
      urlSource = urlSoldOut;
      validSourceList = true;
    } else if (sourceList == GroupType.alreadyBought) {
      source = _itemsAlreadyBought;
      urlSource = urlBought;
      validSourceList = true;
    } else {
      urlSource = urlBase;
    }
    if (destinationList == GroupType.wanted) {
      destination = _itemsWanted;
      urlDestination = urlWanted;
      validDestinationList = true;
    } else if (destinationList == GroupType.soldOut) {
      destination = _itemsSoldOut;
      urlDestination = urlSoldOut;
      validDestinationList = true;
    } else if (destinationList == GroupType.alreadyBought) {
      destination = _itemsAlreadyBought;
      urlDestination = urlBought;
      validDestinationList = true;
    } else {
      urlDestination = urlBase;
    }

    if (validSourceList && validDestinationList) {
      for (Product item in source) {
        if (item.id == id) {
          changeProduct.id = id;
          changeProduct.title = item.title;
          changeProduct.group = destinationList;
          changeProduct.userId = userId;
          changeProduct.index = 0;
          destination.insert(0, changeProduct);
          found = true;
          _updateIndexes(destination);
        }
      }
      if (found) {
        source.removeWhere((element) => element.id == id);
        _updateIndexes(source);

        if (urlSource != urlBase && urlDestination != urlBase) {
          http.put(
            urlSource,
            body: jsonEncode(source),
          );
          http.put(
            urlDestination,
            body: jsonEncode(destination),
          );
        }
        notifyListeners();
      }
    }
  }

  Future<void> changePosition(int oldIndex, int newIndex) async {
    final urlWanted = Uri.parse(constants_links.urlWanted + "?auth=$authToken");
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final items = _itemsWanted.removeAt(oldIndex);
    _itemsWanted.insert(newIndex, items);
    _updateIndexes(_itemsWanted);

    http.put(
      urlWanted,
      body: jsonEncode(_itemsWanted),
    );

    notifyListeners();
  }

  void addNewProduct(String title, String userId) {
    final urlWanted = Uri.parse(constants_links.urlWanted + "?auth=$authToken");
    Product newProduct = Product(
      const Uuid().v1(),
      title,
      userId,
      GroupType.wanted,
      0,
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).toString(),
    );

    print(newProduct.toString());

    _itemsWanted.insert(0, newProduct);
    _updateIndexes(_itemsWanted);
    for (Product item in _itemsWanted) {
      print(item.title + " " + item.runtimeType.toString());
    }

    final encoded = jsonEncode(_itemsWanted,
        toEncodable: (Object? value) => value is Product
            ? value.toJson()
            : throw UnsupportedError('Cannot convert to JSON: $value'));

    http.put(
      urlWanted,
      body: encoded,
    );

    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final urlBase = Uri.parse(constants_links.urlBase + "?auth=$authToken");
    log("fetch");
    try {
      final response = await http.get(urlBase);
      final responseData = json.decode(response.body) as List<dynamic>;
      final List<Product> loadedWantedProducts = [];
      final List<Product> loadedSoldOutProducts = [];
      final List<Product> loadedAlreadyBoughtProducts = [];
      log(responseData.toString());
      for (var subList in responseData) {
        if (subList != null) {
          for (var item in subList) {
            GroupType groupType = GroupType.values.firstWhere(
                (element) => element.toString() == item[constants.group]);
            Product p = Product(
              item[constants.id],
              item[constants.title],
              item[constants.userId],
              groupType,
              item[constants.index],
              item[constants.time],
            );
            if (groupType == GroupType.wanted) {
              loadedWantedProducts.add(p);
            } else if (groupType == GroupType.soldOut) {
              loadedSoldOutProducts.add(p);
            } else if (groupType == GroupType.alreadyBought) {
              loadedAlreadyBoughtProducts.add(p);
            }
          }
        }
      }

      loadedWantedProducts.sort((a, b) => a.index.compareTo(b.index));
      loadedSoldOutProducts.sort((a, b) => a.index.compareTo(b.index));
      loadedAlreadyBoughtProducts.sort((a, b) => a.index.compareTo(b.index));

      _itemsWanted = loadedWantedProducts;
      _itemsSoldOut = loadedSoldOutProducts;
      _itemsAlreadyBought = loadedAlreadyBoughtProducts;
      // setProductsOffline();
      notifyListeners();
    } catch (error) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(constants.products)) {
        if (prefs.getString(constants.products) != null) {
          final data = json.decode(prefs.getString(constants.products)!)
              as Map<String, dynamic>;
          final List<Product> offlineWantedProducts = [];
          final List<Product> offlineSoldOutProducts = [];
          final List<Product> offlineAlreadyBoughtProducts = [];
          for (var item in data[constants.itemsWanted]) {
            Product p = Product(
              item[constants.id],
              item[constants.title],
              item[constants.userId],
              GroupType.wanted,
              item[constants.index],
              item[constants.time],
            );
            offlineWantedProducts.add(p);
          }
          for (var item in data[constants.itemsSoldOut]) {
            Product p = Product(
              item[constants.id],
              item[constants.title],
              item[constants.userId],
              GroupType.soldOut,
              item[constants.index],
              item[constants.time],
            );
            offlineSoldOutProducts.add(p);
          }
          for (var item in data[constants.itemsAlreadyBought]) {
            Product p = Product(
              item[constants.id],
              item[constants.title],
              item[constants.userId],
              GroupType.alreadyBought,
              item[constants.index],
              item[constants.time],
            );
            offlineAlreadyBoughtProducts.add(p);
          }
          offlineWantedProducts.sort((a, b) => a.index.compareTo(b.index));
          offlineSoldOutProducts.sort((a, b) => a.index.compareTo(b.index));
          offlineAlreadyBoughtProducts
              .sort((a, b) => a.index.compareTo(b.index));
          _itemsWanted = offlineWantedProducts;
          _itemsSoldOut = offlineSoldOutProducts;
          _itemsAlreadyBought = offlineAlreadyBoughtProducts;
          notifyListeners();
        }
      }
    }
  }

  Future<void> addLists(
      List<Product> list1, List<Product> list2, List<Product> list3) async {
    final urlBase = Uri.parse(constants_links.urlBase + "=$authToken");

    final List<List<Product>> sendLists = [];
    sendLists.add(list1);
    sendLists.add(list2);
    sendLists.add(list3);

    http.post(
      urlBase,
      body: json.encode(
        sendLists,
      ),
    );
  }

  Future<void> clearRecommendations() async {
    final urlBought = Uri.parse(constants_links.urlBought + "?auth=$authToken");
    List<Product> clearedList = [];
    _itemsAlreadyBought = clearedList;
    await http.put(
      urlBought,
      body: jsonEncode(_itemsAlreadyBought),
    );
    notifyListeners();
  }

  void _updateIndexes(List<Product> list) {
    int index = 0;
    for (Product item in list) {
      item.index = index;
      index++;
    }
  }

  // void setProductsOffline() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final offlineProducts = json.encode({
  //     constants.itemsWanted: _itemsWanted,
  //     constants.itemsSoldOut: _itemsSoldOut,
  //     constants.itemsAlreadyBought: _itemsAlreadyBought,
  //   });
  //   prefs.setString(constants.products, offlineProducts);
  // }
}
