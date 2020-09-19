import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_app/src/Common/Common.dart';
import 'package:food_app/src/LocalDatabase/LocalDatabase.dart';
import 'package:food_app/src/models/fav.dart';
import 'package:food_app/src/models/food_model.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    getDataFromLocalDatabase();
    super.initState();
  }

  void getDataFromLocalDatabase() async {
    Common.foods = [];
    await localDatabase.db.favs().then((value) {
      value.forEach((f) {
        int id = (f.id - 1);
        FirebaseDatabase.instance
            .reference()
            .child("FoodItem")
            .child(f.category)
            .child("$id")
            .once()
            .then((DataSnapshot dataSnapshot) {
          print(dataSnapshot.value.runtimeType);
          Map<dynamic, dynamic> data = dataSnapshot.value;
          localDatabase.db.checkFood(f.id).then((onValue) {
            if (onValue == 1) {
              setState(() {
                Common.foods.add(Food(
                    id: f.id,
                    imagePath: data["imagePath"],
                    category: data["categoryId"],
                    name: data["name"],
                    price: double.parse(data["price"]),
                    discount: double.parse(data["discount"]),
                    ratings: double.parse(data["ratings"]),
                    count: 1,
                    isAdded: true));
              });
            } else {
              setState(() {
                Common.foods.add(Food(
                    id: f.id,
                    imagePath: data["imagePath"],
                    category: data["categoryId"],
                    name: data["name"],
                    price: double.parse(data["price"]),
                    discount: double.parse(data["discount"]),
                    ratings: double.parse(data["ratings"]),
                    count: 1,
                    isAdded: false));
              });
            }
          }).catchError((onError) {
            print(onError);
          });
        }).catchError((e) {
          print(e);
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
        elevation: 0.0,
        title: Text(
          "Favorite",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
          padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
          children: <Widget>[
            Column(
              children: Common.foods.map(_buildFavoriteList).toList(),
            )
          ]),
    );
  }

  Widget _buildFavoriteList(Food food) {
    bool isAdd = food.isAdded;
    bool isFav = true;
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 200.0,
              width: 380.0,
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/giphy.gif",
                image: food.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: Container(
                height: 60.0,
                width: 380.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.black12],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
              ),
            ),
            Positioned(
              left: 10.0,
              bottom: 10.0,
              right: 10.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        food.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                            size: 16.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                            size: 16.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                            size: 16.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                            size: 16.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                            size: 16.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text("(" + food.ratings.toString() + " Reviews)",
                              style: TextStyle(
                                color: Colors.grey,
                              ))
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "\u20B9" + food.price.toString(),
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isAdd = !isAdd;
                            food.isAdded = isAdd;
                            if (isAdd) {
                              localDatabase.db.insertFood(food);
                            } else {
                              localDatabase.db.deleteFood(food.id);
                            }
                          });
                        },
                        child: Icon(
                            isAdd
                                ? Icons.shopping_cart
                                : Icons.add_shopping_cart,
                            color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFav = !isFav;
                            if (isFav) {
                              localDatabase.db.insertFav(
                                  Fav(id: food.id, category: food.category));
                            } else {
                              localDatabase.db.deleteFav(food.id);
                              Common.foods.remove(food);
                            }
                          });
                        },
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.pinkAccent : Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
