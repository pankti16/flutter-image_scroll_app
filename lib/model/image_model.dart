class ImageModel {
  final String id;
  final String author;
  final String downloadUrl;
  final String url;

  ImageModel({required this.id, required this.author, required this.downloadUrl, required this.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      author: json['author'],
      downloadUrl: json['download_url'],
      url: json['url'],
    );
  }

  factory ImageModel.fromJSON(final json) {
    return ImageModel(
      id: json['id'],
      author: json['author'],
      downloadUrl: json['download_url'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'author': author,
      'download_url': downloadUrl,
      'url': url,
    };
  }
}