class Video {
  late String id;
  late String title;
  late String thumbnail;
  late String channel;

  Video({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.channel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'channel': channel,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id']['videoId'] ?? "",
      title: map['snippet']['title'] ?? "",
      thumbnail: map['snippet']['thumbnails']['high']['url'] ?? "",
      channel: map['snippet']['channelTitle'] ?? "",
    );
  }

  // factory Video.fromJson(String source) => Video.fromMap(json.decode(source));
}
