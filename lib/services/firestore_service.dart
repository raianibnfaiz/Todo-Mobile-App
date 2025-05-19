import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference
  CollectionReference todosCollection(String userId) => 
      _firestore.collection('users').doc(userId).collection('todos');
  
  // Add todo
  Future<void> addTodo(String userId, Todo todo) async {
    try {
      await todosCollection(userId).doc(todo.id).set(todo.toJson());
    } catch (e) {
      print('Error adding todo: $e');
      rethrow;
    }
  }
  
  // Update todo
  Future<void> updateTodo(String userId, String todoId, Todo todo) async {
    try {
      await todosCollection(userId).doc(todoId).update(todo.toJson());
    } catch (e) {
      print('Error updating todo: $e');
      rethrow;
    }
  }
  
  // Delete todo
  Future<void> deleteTodo(String userId, String todoId) async {
    try {
      await todosCollection(userId).doc(todoId).delete();
    } catch (e) {
      print('Error deleting todo: $e');
      rethrow;
    }
  }
  
  // Get user todos
  Stream<List<Todo>> getTodos(String userId) {
    return todosCollection(userId)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs
                .map((doc) => Todo.fromJson(doc.data() as Map<String, dynamic>))
                .toList());
  }
} 