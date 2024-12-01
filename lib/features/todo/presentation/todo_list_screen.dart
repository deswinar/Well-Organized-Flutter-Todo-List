import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/domain/auth_bloc.dart';
import 'package:myapp/router/app_router.dart';
import '../domain/todo_bloc.dart';
import '../domain/todo_event.dart';
import '../domain/todo_state.dart';
import '../data/todo_model.dart';
import 'widgets/todo_list_tile.dart';

@RoutePage()
class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dispatch LoadTodos event when the screen is loaded
    final userId = context
        .read<TodoBloc>()
        .todoRepository
        .authRepository
        .getCurrentUser()!
        .uid;
    context
        .read<TodoBloc>()
        .add(LoadTodos(userId: userId)); // Trigger the LoadTodos event

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial || state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodosLoaded) {
            final todos = state.todos;
            if (todos.isEmpty) {
              return const Center(child: Text('No Todos Found.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoListTile(
                  todo: todo,
                  onDelete: () {
                    context.read<TodoBloc>().add(DeleteTodo(todoId: todo.id!));
                  },
                  onComplete: (bool? isChecked) {
                    context.read<TodoBloc>().add(UpdateTodo(
                          todo: todo.copyWith(isCompleted: isChecked ?? false),
                        ));
                  },
                );
              },
            );
          } else if (state is TodoError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unknown State'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        label: const Text('Add Todo'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final todo = TodoModel(
                    title: titleController.text,
                    description: descriptionController.text,
                    userId: context
                        .read<TodoBloc>()
                        .todoRepository
                        .authRepository
                        .getCurrentUser()!
                        .uid,
                  );
                  context.read<TodoBloc>().add(AddTodo(todo: todo));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle logout logic here
                context.read<AuthBloc>().authRepository.signOut();
                context.replaceRoute(LoginRoute()); // Example route
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
