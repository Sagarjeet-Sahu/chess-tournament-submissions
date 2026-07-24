class Tournament{
  int? id;
  String name;
  String location;
  String date;

  Tournament({
    this.id,
    required this.name,
    required this.location,
    required this.date,
  });

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "name": name,
      "location": location,
      "date": date,
    };
  }

  factory Tournament.fromMap(Map<String,dynamic> map){
    return Tournament(
      id: map["id"],
      name: map["name"],
      location: map["location"],
      date: map["date"],
    );
  }
}