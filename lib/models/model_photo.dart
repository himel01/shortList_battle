import 'dart:convert';

class ModelPhoto {
  ModelPhoto({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  factory ModelPhoto.fromJson(Map<String, dynamic> json) {
    return ModelPhoto(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  // factory ModelPhoto.fromJson(String str) => ModelPhoto.fromMap(json.decode(str));
  //
  // String toJson() => json.encode(toMap());
  //
  // factory ModelPhoto.fromMap(Map<String, dynamic> json) => ModelPhoto(
  //   albumId: json["albumId"],
  //   id: json["id"],
  //   title: json["title"],
  //   url: json["url"],
  //   thumbnailUrl: json["thumbnailUrl"],
  // );
  //
  // Map<String, dynamic> toMap() => {
  //   "albumId": albumId,
  //   "id": id,
  //   "title": title,
  //   "url": url,
  //   "thumbnailUrl": thumbnailUrl,
  // };
}
class PhotosList {
  final List<ModelPhoto> photos;

  PhotosList({
    required this.photos,
  });
  factory PhotosList.fromJson(List<dynamic> parsedJson) {

    List<ModelPhoto> photos = <ModelPhoto>[];
    photos = parsedJson.map((i)=>ModelPhoto.fromJson(i)).toList();

    return new PhotosList(
        photos: photos
    );
  }
}