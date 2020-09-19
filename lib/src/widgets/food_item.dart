import 'package:flutter/material.dart';
import 'package:food_app/src/models/fav.dart';
import 'package:food_app/src/models/food_model.dart';
import 'package:food_app/src/LocalDatabase/LocalDatabase.dart';

// ignore: must_be_immutable
class FoodItems extends StatefulWidget {
  Food food;
  FoodItems({@required this.food});

  @override
  _FoodItemsState createState() => _FoodItemsState();
}

class _FoodItemsState extends State<FoodItems> {
  bool isAdd = false;
  bool isFav = false;

  @override
  void initState() {
    localDatabase.db.checkFood(widget.food.id).then((v) {
      if (v == 1) {
        setState(() {
          isAdd = true;
        });
      }
    }).catchError((e) {
      print(e);
    });

    localDatabase.db.checkFav(widget.food.id).then((v) {
      if (v == 1) {
        setState(() {
          isFav = true;
        });
      }
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: 200.0,
            width: 380.0,
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/giphy.gif",
              image: widget.food.imagePath,
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
                      widget.food.name,
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
                        Text("(" + widget.food.ratings.toString() + " Reviews)",
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
                      "\u20B9" + widget.food.price.toString(),
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
                          setState(() {
                            isAdd = !isAdd;
                            if (isAdd) {
                              localDatabase.db.insertFood(widget.food);
                            } else {
                              localDatabase.db.deleteFood(widget.food.id);
                            }
                          });
                        });
                      },
                      child: Icon(
                          isAdd ? Icons.shopping_cart : Icons.add_shopping_cart,
                          color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFav = !isFav;
                          if (isFav) {
                            localDatabase.db.insertFav(Fav(
                                id: widget.food.id,
                                category: widget.food.category));
                          } else {
                            localDatabase.db.deleteFav(widget.food.id);
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
    );
  
  }
}
