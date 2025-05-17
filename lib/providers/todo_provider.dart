import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  
  List<Todo> get todos => _todos;
  List<Todo> get pendingTodos => _todos.where((todo) => !todo.isDone && todo.progress == 0).toList();
  List<Todo> get inProgressTodos => _todos.where((todo) => !todo.isDone && todo.progress > 0 && todo.progress < 100).toList();
  List<Todo> get completedTodos => _todos.where((todo) => todo.isDone || todo.progress == 100).toList();

  TodoProvider() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString('todos');
    
    if (todosString != null) {
      final List<dynamic> todosJson = jsonDecode(todosString);
      _todos = todosJson.map((item) => Todo.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosJson = jsonEncode(_todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', todosJson);
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    saveTodos();
    notifyListeners();
  }

  void updateTodo(String id, Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      saveTodos();
      notifyListeners();
    }
  }

  void toggleTodoStatus(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isDone: !_todos[index].isDone,
        progress: _todos[index].isDone ? _todos[index].progress : 100,
      );
      saveTodos();
      notifyListeners();
    }
  }

  void updateTodoProgress(String id, int progress) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        progress: progress,
        isDone: progress == 100 ? true : _todos[index].isDone,
      );
      saveTodos();
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    saveTodos();
    notifyListeners();
  }
} 