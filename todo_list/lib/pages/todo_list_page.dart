import 'package:flutter/material.dart';
import 'package:todo_list/repositories/todo_repository.dart';

import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = new TodoRepository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;
  @override
  void initState(){
    super.initState();

    todoRepository.getTodoList().then((value){
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Estudar flutter',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xff00d7f3),
                          )
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if(text.isEmpty){
                          setState(() {
                            errorText = "O titulo não pode ser vazio!";
                          });
                          return;
                        }

                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Icon(Icons.add, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todoItem in todos)
                        TodoListItem(todo: todoItem, onDelete: onDelete),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} tarefas pendentes',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Text('Limpar tudo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "A tarefa ${todo.title} foi removida com sucesso!",
          style: TextStyle(color: Color(0xff060709)),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              setState(() {
                todos.insert(deletedTodoPos!, deletedTodo!);
              });
              todoRepository.saveTodoList(todos);
            },
            textColor: const Color(0xff00d7f3),
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog(){
    showDialog(
      context: context,
      builder: (context)  => AlertDialog(
        title: Text("Limpar tudo?"),
        content: Text("Você tem certeza que deseja apagar todas as tarefas?"),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Color(0xff00d7f3) ),
              child: Text("Cancelar"),
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
                deleteAllTodos();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red ),
              child: Text("Limpar tudo"))
        ],
      )
    );
  }

  void deleteAllTodos(){
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
