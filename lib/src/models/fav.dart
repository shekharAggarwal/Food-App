class Fav{
  final int id;
  final String category;

  Fav({this.id,this.category});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
    };
  }
}