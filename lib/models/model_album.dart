class ModelAlbum {
  ModelAlbum({
    required this.userId,
    required this.id,
    required this.title,
  });

  final int userId;
  final int id;
  final String title;

  factory ModelAlbum.fromJson(Map<String, dynamic> json) {
    return ModelAlbum(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,

    );
  }

  // factory ModelAlbum.fromJson(String str) => ModelAlbum.fromMap(json.decode(str));
  //
  // String toJson() => json.encode(toMap());
  //
  // factory ModelAlbum.fromMap(Map<String, dynamic> json) => ModelAlbum(
  //   userId: json["userId"],
  //   id: json["id"],
  //   title: json["title"],
  // );
  //
  Map<String, dynamic> toMap() => {
    "userId": userId,
    "id": id,
    "title": title,
  };
}