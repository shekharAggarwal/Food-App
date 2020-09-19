import 'package:flutter/cupertino.dart';

class Food {
  final int id;
  final String name;
  final String imagePath;
  final String category;
  final double price;
  final double discount;
  final double ratings;
  int count;
  bool isAdded;

  Food(
      {this.id,
      this.name,
      this.imagePath,
      this.category,
      this.price,
      this.discount,
      this.ratings,
      @required this.count,
      this.isAdded});

  void setCount(int count){
    this.count = count; 
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'count': count,
    };
  }
}
