class Post {
  final int id;
  final int userId;
  final String title;
  final String content;

  Post(
      {required this.id,
      required this.userId,
      required this.title,
      required this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
    };
  }


  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
