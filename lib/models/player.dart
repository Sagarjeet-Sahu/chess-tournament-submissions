class Player{
  int? id;
  String name;
  int age;
  int rating;

  Player({
    this.id,
    required this.name,
    required this.age,
    required this.rating,
  }) ;

  Map<String,dynamic> toMap(){
    return{
      "id":id,
      "name":name,
      "age":age,
      "rating":rating,
    };
  }

  factory Player.fromMap(Map<String,dynamic> map){
    return Player(
      id:map["id"],
      name:map["name"],
      age:map["age"],
      rating:map["rating"],
    );
  }
}