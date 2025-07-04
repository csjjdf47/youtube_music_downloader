class Video {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;
  final Duration duration;
  final String url;

  Video({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.duration,
    required this.url,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: Duration(seconds: json['duration']),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration.inSeconds,
      'url': url,
    };
  }
}
