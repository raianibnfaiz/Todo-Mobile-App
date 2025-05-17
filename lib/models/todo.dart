class Todo {
  final String id;
  String title;
  String description;
  bool isDone;
  int progress; // 0-100 percentage

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isDone = false,
    this.progress = 0,
  });

  Todo copyWith({
    String? title,
    String? description,
    bool? isDone,
    int? progress,
  }) {
    return Todo(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'progress': progress,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isDone: json['isDone'],
      progress: json['progress'],
    );
  }
} 