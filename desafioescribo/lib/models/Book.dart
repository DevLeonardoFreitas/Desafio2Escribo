class Book {
  int? id;
  String? title;
  String? author;
  String? coverUrl;
  String? downloadUrl;

  Book({this.id, this.title, this.author, this.coverUrl, this.downloadUrl});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    coverUrl = json['cover_url'];
    downloadUrl = json['download_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['author'] = this.author;
    data['cover_url'] = this.coverUrl;
    data['download_url'] = this.downloadUrl;
    return data;
  }
}
