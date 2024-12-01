// lib/features/todo/domain/todo_state.dart
import '../data/todo_model.dart';

abstract class TodoState {
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<TodoModel> todos;

  TodosLoaded({required this.todos});

  @override
  List<Object?> get props => [todos];
}

class TodoError extends TodoState {
  final String message;

  TodoError({required this.message});

  @override
  List<Object?> get props => [message];
}
