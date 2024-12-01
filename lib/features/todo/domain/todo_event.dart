// lib/features/todo/domain/todo_event.dart
import '../data/todo_model.dart';

abstract class TodoEvent {
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {
  final String userId;

  LoadTodos({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AddTodo extends TodoEvent {
  final TodoModel todo;

  AddTodo({required this.todo});

  @override
  List<Object?> get props => [todo];
}

class UpdateTodo extends TodoEvent {
  final TodoModel todo;

  UpdateTodo({required this.todo});

  @override
  List<Object?> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final String todoId;

  DeleteTodo({required this.todoId});

  @override
  List<Object?> get props => [todoId];
}
