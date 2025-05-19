import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class TodoProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService;
  List<Todo> _todos = [];
  StreamSubscription<List<Todo>>? _todosSubscription;
  
  TodoProvider({required AuthService authService}) : _authService = authService {
    _initTodos();
  }
  
  // Initialize todos when the user changes
  void _initTodos() {
    // Cancel previous subscription if exists
    _todosSubscription?.cancel();
    
    // Subscribe to auth state changes
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        // User is logged in, listen to their todos
        _todosSubscription = _firestoreService.getTodos(user.uid).listen((todos) {
          _todos = todos;
          notifyListeners();
        });
      } else {
        // User is logged out, clear todos
        _todos = [];
        notifyListeners();
      }
    });
  }
  
  // Clean up subscriptions
  @override
  void dispose() {
    _todosSubscription?.cancel();
    super.dispose();
  }
  
  // Getters
  List<Todo> get todos => _todos;
  List<Todo> get pendingTodos => _todos.where((todo) => !todo.isDone && todo.progress == 0).toList();
  List<Todo> get inProgressTodos => _todos.where((todo) => !todo.isDone && todo.progress > 0 && todo.progress < 100).toList();
  List<Todo> get completedTodos => _todos.where((todo) => todo.isDone || todo.progress == 100).toList();
  
  // Check if user is logged in
  bool get isUserLoggedIn => _authService.isLoggedIn;
  
  // Get current user ID
  String? get userId => _authService.currentUser?.uid;
  
  // CRUD operations
  Future<void> addTodo(Todo todo) async {
    if (!isUserLoggedIn) return;
    
    try {
      await _firestoreService.addTodo(userId!, todo);
    } catch (e) {
      print('Error adding todo: $e');
    }
  }
  
  Future<void> updateTodo(String id, Todo updatedTodo) async {
    if (!isUserLoggedIn) return;
    
    try {
      await _firestoreService.updateTodo(userId!, id, updatedTodo);
    } catch (e) {
      print('Error updating todo: $e');
    }
  }
  
  Future<void> toggleTodoStatus(String id) async {
    if (!isUserLoggedIn) return;
    
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final updatedTodo = _todos[index].copyWith(
        isDone: !_todos[index].isDone,
        progress: _todos[index].isDone ? _todos[index].progress : 100,
      );
      
      await updateTodo(id, updatedTodo);
    }
  }
  
  Future<void> updateTodoProgress(String id, int progress) async {
    if (!isUserLoggedIn) return;
    
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final updatedTodo = _todos[index].copyWith(
        progress: progress,
        isDone: progress == 100 ? true : _todos[index].isDone,
      );
      
      await updateTodo(id, updatedTodo);
    }
  }
  
  Future<void> deleteTodo(String id) async {
    if (!isUserLoggedIn) return;
    
    try {
      await _firestoreService.deleteTodo(userId!, id);
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
} 