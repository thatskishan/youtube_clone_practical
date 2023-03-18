class Channel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final String videoCount;
  final String uploadPlayListId;
  List videos;

  Channel({
    required this.id,
    required this.title,
    required this.profilePictureUrl,
    required this.subscriberCount,
    required this.videoCount,
    required this.uploadPlayListId,
    required this.videos,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['title'],
      profilePictureUrl: map['profilePictureUrl'],
      subscriberCount: map['subscriberCount'],
      videoCount: map['videoCount'],
      uploadPlayListId: map['uploadPlayListId'],
      videos: ['videos'],
    );
  }
}
