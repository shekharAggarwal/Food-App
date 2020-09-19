import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_app/src/models/category_model.dart';
import 'package:food_app/src/models/food_model.dart';
import 'package:food_app/src/widgets/food_item.dart';

// ignore: must_be_immutable
class TopItem extends StatefulWidget {
  Category category;
  TopItem({this.category});
  @override
  _TopItemState createState() => _TopItemState();
}

class _TopItemState extends State<TopItem> {
  List<Food> foods = [];
  @override
  void initState() {
    getDataFromFirebase(widget.category.categoryId);
    super.initState();
  }

  void getDataFromFirebase(String categoryId) async {
    FirebaseDatabase.instance
        .reference()
        .child("FoodItem")
        .child(categoryId)
        .once()
        .then((DataSnapshot snapshot) {
      List<dynamic> lists = snapshot.value;
      lists.forEach((f) {
        Map<dynamic, dynamic> data = f;
        setState(() {
          foods.add(Food(
              id: int.parse(data["id"]),
              imagePath: data["imagePath"],
              category: data["categoryId"],
              name: data["name"],
              price: double.parse(data["price"]),
              discount: double.parse(data["discount"]),
              ratings: double.parse(data["ratings"]),
              count: 1));
        });
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0.0,
        title: Text(
          widget.category.categoryName,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: foods.map(_buildFoodItems).toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItems(Food food) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: FoodItems(
        food: food,
      ),
    );
  }
}
