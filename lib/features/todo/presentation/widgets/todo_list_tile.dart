import 'package:flutter/material.dart';
import '../../data/todo_model.dart';

class TodoListTile extends StatelessWidget {
  final TodoModel todo;
  final Function onDelete;
  final Function(bool?) onComplete;

  const TodoListTile({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Transform.scale(
            scale: 1.5, // Enlarges the checkbox slightly for a modern feel
            child: Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: todo.isCompleted,
              onChanged: onComplete,
              activeColor: Colors.teal,
              checkColor: Colors.white,
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: todo.isCompleted ? Colors.grey : Colors.black87,
            ),
          ),
          subtitle: Text(
            todo.description,
            style: TextStyle(
              fontSize: 14,
              color: todo.isCompleted ? Colors.grey : Colors.black54,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () => onDelete(),
          ),
        ),
      ),
    );
  }
}
