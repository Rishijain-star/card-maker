class Task {
  final String id;
  final String title;
  final String desc;
  final bool dueToday;
  final DateTime? dueDate;
  final List<Comment> comments;
  final int priority; // 1=red, 2=gold, 3=blue, 4=none
  final String? assignedUser;
  final List<String> attachments;
  final List<String> evidencePhotos;
  final String status;
  final String? time;
  final bool isCompleted;
  final List<Task> subtasks;

  Task({
    required this.id,
    required this.title,
    required this.desc,
    required this.dueToday,
    this.dueDate,
    this.comments = const [],
    this.priority = 4,
    this.assignedUser,
    this.attachments = const [],
    this.evidencePhotos = const [],
    this.status = 'Pending',
    this.time,
    this.isCompleted = false,
    this.subtasks = const [],
  });

  int get commentCount => comments.length;

  Task copyWith({
    String? id,
    String? title,
    String? desc,
    bool? dueToday,
    DateTime? dueDate,
    List<Comment>? comments,
    int? priority,
    String? assignedUser,
    List<String>? attachments,
    List<String>? evidencePhotos,
    String? status,
    String? time,
    bool? isCompleted,
    List<Task>? subtasks,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      dueToday: dueToday ?? this.dueToday,
      dueDate: dueDate ?? this.dueDate,
      comments: comments ?? this.comments,
      priority: priority ?? this.priority,
      assignedUser: assignedUser ?? this.assignedUser,
      attachments: attachments ?? this.attachments,
      evidencePhotos: evidencePhotos ?? this.evidencePhotos,
      status: status ?? this.status,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}

class Comment {
  final String id;
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.userName,
    required this.text,
    required this.timestamp,
  });
}

/// Parses API `comments` arrays on tasks (id, body, created_at, user).
List<Comment> commentsFromApiJson(dynamic raw) {
  if (raw is! List) return const [];
  final out = <Comment>[];
  for (final item in raw) {
    if (item is! Map) continue;
    final c = commentFromApiMap(Map<String, dynamic>.from(item));
    if (c != null) out.add(c);
  }
  return out;
}

Comment? commentFromApiMap(Map<String, dynamic> m) {
  final user = m['user'];
  var userName = 'User';
  if (user is Map && user['name'] != null) {
    userName = user['name'].toString();
  }
  final id = (m['id'] ?? '').toString();
  final body = (m['body'] ?? '').toString();
  final tsRaw = m['created_at']?.toString();
  final ts = DateTime.tryParse(tsRaw ?? '') ?? DateTime.now();
  if (id.isEmpty && body.isEmpty) return null;
  return Comment(
    id: id.isEmpty ? '${DateTime.now().microsecondsSinceEpoch}' : id,
    userName: userName,
    text: body,
    timestamp: ts,
  );
}

class Phase {
  final String id;
  final String title;
  final List<Task> tasks;

  Phase({required this.id, required this.title, this.tasks = const []});

  Phase copyWith({String? id, String? title, List<Task>? tasks}) {
    return Phase(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }
}

class Project {
  final String id;
  final String title;
  final List<Phase> phases;
  final DateTime createdAt;
  final bool isFromTemplate;

  Project({
    required this.id,
    required this.title,
    this.phases = const [],
    required this.createdAt,
    this.isFromTemplate = false,
  });

  Project copyWith({
    String? id,
    String? title,
    List<Phase>? phases,
    DateTime? createdAt,
    bool? isFromTemplate,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      phases: phases ?? this.phases,
      createdAt: createdAt ?? this.createdAt,
      isFromTemplate: isFromTemplate ?? this.isFromTemplate,
    );
  }
}

class ProjectTemplate {
  final String id;
  final String name;
  final String category;
  final List<Phase> phases;

  ProjectTemplate({
    required this.id,
    required this.name,
    this.category = 'General',
    this.phases = const [],
  });
}

