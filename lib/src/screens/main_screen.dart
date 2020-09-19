import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/src/pages/favorite_page.dart';
import 'package:food_app/src/pages/home_page.dart';
import 'package:food_app/src/pages/order_page.dart';
import 'package:food_app/src/pages/profile_page.dart';
import 'package:food_app/src/pages/sigin_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  // Pages
  HomePage homePage;
  OrderPage orderPage;
  FavoritePage favoritePage;
  ProfilePage profilePage;
  LoginPage loginPage;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    // call the fetch method on food
    homePage = HomePage();
    orderPage = OrderPage();
    favoritePage = FavoritePage();
    profilePage = ProfilePage();
    loginPage = LoginPage();
    pages = [homePage, orderPage, favoritePage, profilePage, loginPage];
    currentPage = homePage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (index) {
          setState(() {
            if (index == 3) {
              User user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
              } else {
                currentTab = index;
                currentPage = pages[index];
              }
            } else {
              currentTab = index;
              currentPage = pages[index];
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            title: Text("Orders"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            title: Text("Favorite"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text("Profile"),
          ),
        ],
      ),
      body: currentPage,
    );
  }
}
