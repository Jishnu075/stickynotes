class Note {
  final String id;
  final String title;
  final String? description;
  final DateTime due;
  final DateTime lastEdited;
  final bool isFavorite;
  final bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.due,
    required this.lastEdited,
    required this.isFavorite,
    required this.isPinned,
  });
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due': due.microsecondsSinceEpoch,
      'lastEdited': lastEdited.microsecondsSinceEpoch,
      'isFavorite': isFavorite ? 1 : 0,
      'isPinned': isPinned ? 1 : 0,
    };
  }
}
