class SongModel {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String filePath;
  final Duration duration;
  final String? albumArt;
  bool isLiked;
  int playCount;
  final DateTime dateAdded;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filePath,
    required this.duration,
    this.albumArt,
    this.isLiked = false,
    this.playCount = 0,
    DateTime? dateAdded,
  }) : dateAdded = dateAdded ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'filePath': filePath,
      'duration': duration.inMilliseconds,
      'albumArt': albumArt,
      'isLiked': isLiked ? 1 : 0,
      'playCount': playCount,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      title: map['title'] ?? 'Unknown Title',
      artist: map['artist'] ?? 'Unknown Artist',
      album: map['album'] ?? 'Unknown Album',
      filePath: map['filePath'] ?? '',
      duration: Duration(milliseconds: map['duration'] ?? 0),
      albumArt: map['albumArt'],
      isLiked: map['isLiked'] == 1,
      playCount: map['playCount'] ?? 0,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded'] ?? 0),
    );
  }

  SongModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? filePath,
    Duration? duration,
    String? albumArt,
    bool? isLiked,
    int? playCount,
    DateTime? dateAdded,
  }) {
    return SongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      albumArt: albumArt ?? this.albumArt,
      isLiked: isLiked ?? this.isLiked,
      playCount: playCount ?? this.playCount,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  String get durationString {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SongModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}