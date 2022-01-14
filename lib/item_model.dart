class ItemTodo{
  final int? id;
  final String title;
  final String description;

ItemTodo({
  this.id,
  required this.title,
  required this.description,
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString(),
    };
  }

    @override
  String toString() {
    return 'items{id: $id, title: $title, description: $description}';
  }
}