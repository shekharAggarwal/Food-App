import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_app/src/Common/Common.dart';
import 'package:food_app/src/models/category_model.dart';
import 'package:food_app/src/models/food_model.dart';
import 'package:food_app/src/widgets/bought_foods.dart';
import 'package:food_app/src/widgets/food_category.dart';
import 'package:food_app/src/widgets/search_field.dart';
import 'package:food_app/src/widgets/tophomeinfo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Food> _foods = [];

  @override
  void initState() {
    getFirebaseItem();
    getFirebaseData();
    super.initState();
  }

  void getFirebaseItem() async {
    Common.categories = [];
    FirebaseDatabase.instance
        .reference()
        .child("Category")
        .once()
        .then((DataSnapshot dataSnapshot) {
      List<dynamic> value = dataSnapshot.value;
      value.forEach((f) {
        Map<dynamic, dynamic> data = f;
        setState(() {
          Common.categories.add(Category(
              categoryName: data["itemName"],
              categoryId: data["categoryId"],
              iamgePath: data["itemImage"],
              numberOfItems: int.parse(data["itemCount"]),
              id: data["id"]));
        });
      });
    }).catchError((e) {
      print(e);
    });
  }

  void getFirebaseData() async {
    _foods = [];
    FirebaseDatabase.instance
        .reference()
        .child("FoodItem")
        .child("0")
        .once()
        .then((DataSnapshot snapshot) {
      List<dynamic> value = snapshot.value;
      value.forEach((f) {
        Map<dynamic, dynamic> data = f;
        setState(() {
          _foods.add(Food(
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
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: ListView(
          padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
          children: <Widget>[
            TopHomeInfo(),
            FoodCategory(),
            SizedBox(
              height: 20.0,
            ),
            SearchField(),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Frequently Bought Foods",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "View All",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: _foods.map(_buildFoodItems).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildFoodItems(Food food) {
  return Container(
    margin: EdgeInsets.only(bottom: 20.0),
    child: BoughtFoods(
      id: food.id,
      name: food.name,
      price: food.price,
      category: food.category,
      imagePath: food.imagePath,
      discount: food.discount,
      ratings: food.ratings,
    ),
  );
}
