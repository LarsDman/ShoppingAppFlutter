import 'package:flutter/foundation.dart';
import 'package:my_app/models/group_type.dart';

class Product extends ChangeNotifier {
  String id;
  String title;
  String userId;
  GroupType group;
  int index;
  String time;

  Product(
    this.id,
    this.title,
    this.userId,
    this.group,
    this.index,
    this.time,
  );

  void toggleGroup(GroupType newGroup) {
    group = newGroup;
    title = "Changed";
    print("New group: " + group.toString() + "New name " + title);
    notifyListeners();
  }

  void changeTitle(GroupType newGroup) {
    group = newGroup;
    notifyListeners();
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Product id: " +
        id +
        " title: " +
        title +
        " userId: " +
        userId +
        " group: " +
        group.toString() +
        " index: " +
        index.toString() +
        " time: " +
        time.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "userId": userId,
      "group": group.toString(),
      "index": index,
      "time": time,
    };
  }

  String renderTime() {
    DateTime parsedTime = DateTime.parse(time);
    String result = parsedTime.day.toString() +
        "." +
        parsedTime.month.toString() +
        "." +
        parsedTime.year.toString();
    return result;
  }
}
