// lib/features/todo/domain/todo.dart
class TodoModel {
  final String? id;
  final String title;
  final String description;
  final bool isCompleted;
  final String userId;

  TodoModel({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.userId,
  });

  // The copyWith method
  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? userId,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,  // userId should be passed if needed
    );
  }

  // Convert Firestore data to Todo object
  factory TodoModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TodoModel(
      id: id,
      title: data['title'],
      description: data['description'],
      isCompleted: data['isCompleted'] ?? false,
      userId: data['userId'],
    );
  }

  // Convert Todo object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }
}
