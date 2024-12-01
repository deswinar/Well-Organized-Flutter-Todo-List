// lib/features/todo/domain/todo_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc(this.todoRepository) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await todoRepository.getTodos(event.userId);
        emit(TodosLoaded(todos: todos));
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    });

    on<AddTodo>((event, emit) async {
      try {
        await todoRepository.addTodo(event.todo);
        add(LoadTodos(userId: event.todo.userId));
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    });

    on<UpdateTodo>((event, emit) async {
      try {
        await todoRepository.updateTodo(event.todo);
        add(LoadTodos(userId: event.todo.userId));
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    });

    on<DeleteTodo>((event, emit) async {
      try {
        await todoRepository.deleteTodo(event.todoId);
        add(LoadTodos(userId: state.props.first.toString()));
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    });
  }
}
