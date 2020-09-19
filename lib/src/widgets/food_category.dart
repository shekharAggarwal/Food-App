import 'package:flutter/widgets.dart';
import 'package:food_app/src/Common/Common.dart';
import 'package:food_app/src/widgets/food_card.dart';
class FoodCategory extends StatefulWidget {
  @override
  _FoodCategoryState createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:80.0,
      child:ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: Common.categories.length,
      itemBuilder: (BuildContext context,int index){
        return FoodCard(
          categoryName: Common.categories[index].categoryName,
          imagePath: Common.categories[index].iamgePath,
          numberOfItems: Common.categories[index].numberOfItems,
          category: Common.categories[index],
        );
      },
    )
    );
  }
}