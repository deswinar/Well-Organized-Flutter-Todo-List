// Suggested code may be subject to a license. Learn more: ~LicenseLog:2519703429.
// lib/features/todo/data/todo_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/data/auth_repository.dart';
import 'todo_model.dart';

class TodoRepository {
  final FirebaseFirestore _firestore;
  final AuthRepository authRepository;

  TodoRepository(this._firestore, this.authRepository);

  // Get current user ID from AuthRepository
  String? get userId => authRepository.getCurrentUser()?.uid;

  Future<List<TodoModel>> getTodos(String userId) async {
    final querySnapshot = await _firestore
        .collection('todos')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => TodoModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> addTodo(TodoModel todoModel) async {
    await _firestore.collection('todos').add(todoModel.toMap());
  }

  Future<void> updateTodo(TodoModel todoModel) async {
    await _firestore.collection('todos').doc(todoModel.id).update(todoModel.toMap());
  }

  Future<void> deleteTodo(String id) async {
    await _firestore.collection('todos').doc(id).delete();
  }
}
