class Note {
  final int? id;
  final String title;
  final String? description;
  final DateTime due;
  final DateTime lastEdited;
  final bool isFavorite;
  final bool isPinned;
  final String colorHEX;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.due,
    required this.lastEdited,
    required this.isFavorite,
    required this.isPinned,
    required this.colorHEX,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due': due.millisecondsSinceEpoch,
      'lastEdited': lastEdited.millisecondsSinceEpoch,
      'isFavorite': isFavorite ? 1 : 0,
      'isPinned': isPinned ? 1 : 0,
      'colorHEX': colorHEX,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] as String,
      description: map['description'] as String?,
      due: DateTime.fromMillisecondsSinceEpoch(map['due'] as int),
      lastEdited: DateTime.fromMillisecondsSinceEpoch(map['lastEdited'] as int),
      isFavorite: (map['isFavorite'] as int) == 1,
      isPinned: (map['isPinned'] as int) == 1,
      colorHEX: map['colorHEX'],
    );
  }
}
