import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_app/src/Common/Common.dart';
import 'package:food_app/src/LocalDatabase/LocalDatabase.dart';
import 'package:food_app/src/models/food_model.dart';
import 'package:food_app/src/pages/sigin_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    getListoFOrder();
    super.initState();
  }

  Price pic = new Price(discount:0.0,total:0.0);

  void getListoFOrder() async {
    Common.foods = [];
    await localDatabase.db.foods().then((onValue) {
      onValue.forEach((f) {
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
          setState(() {
            Common.foods.add(Food(
                id: f.id,
                imagePath: data["imagePath"],
                category: data["categoryId"],
                name: data["name"],
                price: double.parse(data["price"]),
                discount: double.parse(data["discount"]),
                ratings: double.parse(data["ratings"]),
                count: f.count));
            pic = calPrice();
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
        title: Text(
          "Your Food Cart",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                children: Common.foods.map(_orderFood).toList(),
              ),
              _buildTotalContainer(context)
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderFood(Food food) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 75.0,
              width: 45.0,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: Color(0xFFD3D3D3),
                  ),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        food.count += 1;
                        pic = calPrice();
                      });
                      localDatabase.db
                          .updateFood(food.id, food.count)
                          .catchError((e) {
                        print(e);
                      });
                    },
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: Color(0xFFD3D3D3),
                    ),
                  ),
                  Text(
                    "${food.count}",
                    style: TextStyle(fontSize: 18.0, color: Color(0xFFD3D3D3)),
                  ),
                  InkWell(
                    onTap: () {
                      if (food.count > 1) {
                        setState(() {
                          food.count -= 1;
                          pic = calPrice();
                        });
                        localDatabase.db
                            .updateFood(food.id, food.count)
                            .catchError((e) {
                          print(e);
                        });
                      }
                    },
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFFD3D3D3),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(5.0, 5.0))
                  ]),
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/giphy.gif",
                image: food.imagePath,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${food.name}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${food.price}",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 25.0,
                  width: 120.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Chicken",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                "x",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  localDatabase.db.deleteFood(food.id);
                  Common.foods.remove(food);
                  pic = calPrice();
                });
              },
              child: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTotalContainer(BuildContext context) {
    return Container(
      height: 220.0,
      margin: EdgeInsets.only(
        top: 20.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Cart Total",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "\u20B9 ${pic.total}",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Discount",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "\u20B9 ${pic.discount}",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Tax",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "\u20B9 0.5",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Divider(
            height: 40.0,
            color: Color(0xFFD3D3D3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Sub Total",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "\u20B9 ${pic.total - pic.discount}",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0)),
              child: Center(
                child: Text(
                  "Proceed to Checkout",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Price calPrice() {
    Price pic = new Price();
    pic.total = 0;
    pic.discount = 0;
    Common.foods.forEach((Food f) {
      pic.total = pic.total + (f.price * f.count);
      pic.discount = pic.discount + (f.discount * f.count);
    });
    return pic;
  }
}

class Price {
  double discount;
  double total;
  Price({this.discount, this.total});
}
