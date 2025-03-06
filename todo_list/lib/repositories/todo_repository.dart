import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

class TodoRepository {

  TodoRepository(){
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value ;
      print(sharedPreferences.getString("todo_list"));
    });
  }

  late SharedPreferences sharedPreferences;

  void saveTodoList(List<Todo> todos){
    final String jsonString = json.encode(todos);
    sharedPreferences.setString("todo_list", jsonString);
  }
}