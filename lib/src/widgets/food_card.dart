import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_app/src/models/category_model.dart';
import 'package:food_app/src/screens/top_item.dart';

// ignore: must_be_immutable
class FoodCard extends StatelessWidget {
  final String categoryName;
  final String imagePath;
  final int numberOfItems;

  Category category;

  FoodCard({this.categoryName, this.imagePath, this.numberOfItems,this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 20.0),
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TopItem(category:category,)));
          },
            child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Image(
                    image: AssetImage(imagePath),
                    height: 65.0,
                    width: 65.0,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        categoryName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      Text("$numberOfItems+ Kinds")
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
