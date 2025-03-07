import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

const todoListString ='todo_list';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListString) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.FromJson(e)).toList();
  }
  void saveTodoList(List<Todo> todos){
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(todoListString, jsonString);
  }
}