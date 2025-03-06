class Todo{

  Todo({required this.title, required this.dateTime});

  String title;
  DateTime dateTime;

  Map<String,dynamic> toJson (){
    return{
    'title': title,
    'DateTime': dateTime.toIso8601String(),
    };
  }

}