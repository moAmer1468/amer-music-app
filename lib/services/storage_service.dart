import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/song_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  List<SongModel> _songs = [];
  List<SongModel> _recentSongs = [];
  List<SongModel> _favoriteSongs = [];

  List<SongModel> get songs => _songs;
  List<SongModel> get recentSongs => _recentSongs;
  List<SongModel> get favoriteSongs => _favoriteSongs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFavoriteSongs();
    _loadRecentSongs();
  }

  Future<bool> requestPermissions() async {
    final status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      // Try with media permissions for Android 13+
      final mediaStatus = await Permission.audio.request();
      return mediaStatus.isGranted;
    }
    return status.isGranted;
  }

  Future<void> scanForMusic() async {
    if (!await requestPermissions()) {
      throw Exception('Storage permission denied');
    }

    _songs.clear();
    final List<Directory> directories = [];

    try {
      // Get external storage directories
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        directories.add(externalDir);
      }

      // Common music directories
      const musicPaths = [
        '/storage/emulated/0/Music',
        '/storage/emulated/0/Download',
        '/storage/emulated/0/Downloads',
        '/sdcard/Music',
        '/sdcard/Download',
        '/sdcard/Downloads',
      ];

      for (final path in musicPaths) {
        final dir = Directory(path);
        if (await dir.exists()) {
          directories.add(dir);
        }
      }

      for (final directory in directories) {
        await _scanDirectory(directory);
      }

      // Sort songs by title
      _songs.sort((a, b) => a.title.compareTo(b.title));
    } catch (e) {
      print('Error scanning for music: $e');
    }
  }

  Future<void> _scanDirectory(Directory directory) async {
    try {
      final entities = await directory.list(recursive: true).toList();
      
      for (final entity in entities) {
        if (entity is File && _isAudioFile(entity.path)) {
          final song = await _createSongFromFile(entity);
          if (song != null) {
            _songs.add(song);
          }
        }
      }
    } catch (e) {
      print('Error scanning directory ${directory.path}: $e');
    }
  }

  bool _isAudioFile(String path) {
    const audioExtensions = ['.mp3', '.m4a', '.aac', '.wav', '.flac', '.ogg', '.wma'];
    final extension = path.toLowerCase().split('.').last;
    return audioExtensions.contains('.$extension');
  }

  Future<SongModel?> _createSongFromFile(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final nameWithoutExtension = fileName.split('.').first;
      
      // Basic parsing - in a real app, you'd use a metadata library
      final parts = nameWithoutExtension.split(' - ');
      final title = parts.length > 1 ? parts[1] : nameWithoutExtension;
      final artist = parts.isNotEmpty ? parts[0] : 'Unknown Artist';
      
      final stat = await file.stat();
      
      return SongModel(
        id: file.path.hashCode.toString(),
        title: title,
        artist: artist,
        album: 'Unknown Album',
        filePath: file.path,
        duration: const Duration(minutes: 3, seconds: 30), // Placeholder
        dateAdded: stat.modified,
      );
    } catch (e) {
      print('Error creating song from file: $e');
      return null;
    }
  }

  Future<void> toggleFavorite(SongModel song) async {
    song.isLiked = !song.isLiked;
    
    if (song.isLiked) {
      if (!_favoriteSongs.contains(song)) {
        _favoriteSongs.add(song);
      }
    } else {
      _favoriteSongs.remove(song);
    }
    
    await _saveFavoriteSongs();
  }

  Future<void> addToRecent(SongModel song) async {
    _recentSongs.removeWhere((s) => s.id == song.id);
    _recentSongs.insert(0, song);
    
    if (_recentSongs.length > 20) {
      _recentSongs = _recentSongs.take(20).toList();
    }
    
    await _saveRecentSongs();
  }

  Future<void> incrementPlayCount(SongModel song) async {
    song.playCount++;
    await addToRecent(song);
  }

  List<SongModel> getMostPlayed() {
    final sorted = List<SongModel>.from(_songs);
    sorted.sort((a, b) => b.playCount.compareTo(a.playCount));
    return sorted.take(10).toList();
  }

  List<SongModel> searchSongs(String query) {
    if (query.isEmpty) return _songs;
    
    final lowerQuery = query.toLowerCase();
    return _songs.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
             song.artist.toLowerCase().contains(lowerQuery) ||
             song.album.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Theme and settings
  Future<bool> isDarkMode() async {
    return _prefs?.getBool('dark_mode') ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool('dark_mode', value);
  }

  Future<String> getLanguage() async {
    final language = _prefs?.getString('language') ?? 'en';
    print('StorageService: Retrieved language: $language');
    return language;
  }

  Future<void> setLanguage(String language) async {
    print('StorageService: Setting language to: $language');
    await _prefs?.setString('language', language);
  }

  // Current playback state
  Future<void> savePlaybackState({
    required String songId,
    required Duration position,
    required bool isPlaying,
  }) async {
    await _prefs?.setString('current_song_id', songId);
    await _prefs?.setInt('current_position', position.inMilliseconds);
    await _prefs?.setBool('is_playing', isPlaying);
  }

  Future<Map<String, dynamic>?> getPlaybackState() async {
    final songId = _prefs?.getString('current_song_id');
    if (songId == null) return null;

    return {
      'songId': songId,
      'position': Duration(milliseconds: _prefs?.getInt('current_position') ?? 0),
      'isPlaying': _prefs?.getBool('is_playing') ?? false,
    };
  }

  Future<void> _saveFavoriteSongs() async {
    final songIds = _favoriteSongs.map((song) => song.id).toList();
    await _prefs?.setStringList('favorite_songs', songIds);
  }

  void _loadFavoriteSongs() {
    final songIds = _prefs?.getStringList('favorite_songs') ?? [];
    _favoriteSongs = _songs.where((song) => songIds.contains(song.id)).toList();
    
    // Update isLiked status
    for (final song in _songs) {
      song.isLiked = songIds.contains(song.id);
    }
  }

  Future<void> _saveRecentSongs() async {
    final songIds = _recentSongs.map((song) => song.id).toList();
    await _prefs?.setStringList('recent_songs', songIds);
  }

  void _loadRecentSongs() {
    final songIds = _prefs?.getStringList('recent_songs') ?? [];
    _recentSongs = songIds
        .map((id) => _songs.firstWhere((song) => song.id == id,
            orElse: () => SongModel(
                id: '', title: '', artist: '', album: '', filePath: '', duration: Duration.zero)))
        .where((song) => song.id.isNotEmpty)
        .toList();
  }
}