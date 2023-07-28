const String tableNotes = "notes";

class Note {
  final int? id;
  final String? title;
  final String? descriptions;
  const Note({
    this.id,
    this.title,
    this.descriptions,
  });
  Map<String, Object?> toJson() => {
        NotesFields.id: id,
        NotesFields.title: title,
        NotesFields.descriptions: descriptions,
      };
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NotesFields.id] as int?,
        title: json[NotesFields.title] as String,
        descriptions: json[NotesFields.descriptions] as String,
      );
  Note copy({
    int? id,
    String? title,
    String? description,
  }) =>
      Note(
          id: id ?? this.id,
          title: title ?? this.title,
          descriptions: description ?? descriptions);
}

class NotesFields {
  static final List<String> values = [
    id,
    title,
    descriptions,
  ];
  static const String id = "_id";
  static const String title = "_title";
  static const String descriptions = "_desorption";
}
