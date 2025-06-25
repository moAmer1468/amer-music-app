import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/song_model.dart';
import 'storage_service.dart';

enum PlayerState {
  stopped,
  playing,
  paused,
  loading,
}

enum RepeatMode {
  none,
  one,
  all,
}

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final StorageService _storageService = StorageService();

  // Current state
  SongModel? _currentSong;
  PlayerState _playerState = PlayerState.stopped;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isShuffleEnabled = false;
  RepeatMode _repeatMode = RepeatMode.none;
  double _volume = 1.0;

  // Playlist management
  List<SongModel> _currentPlaylist = [];
  int _currentIndex = -1;

  // Getters
  SongModel? get currentSong => _currentSong;
  PlayerState get playerState => _playerState;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isPlaying => _playerState == PlayerState.playing;
  bool get isPaused => _playerState == PlayerState.paused;
  bool get isShuffleEnabled => _isShuffleEnabled;
  RepeatMode get repeatMode => _repeatMode;
  double get volume => _volume;
  List<SongModel> get currentPlaylist => _currentPlaylist;
  int get currentIndex => _currentIndex;

  // Progress as percentage (0.0 to 1.0)
  double get progress {
    if (_totalDuration.inMilliseconds == 0) return 0.0;
    return _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;
  }

  Future<void> initialize() async {
    // Set up audio player listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          _playerState = PlayerState.playing;
          break;
        case PlayerState.paused:
          _playerState = PlayerState.paused;
          break;
        case PlayerState.stopped:
          _playerState = PlayerState.stopped;
          break;
        default:
          _playerState = PlayerState.stopped;
          break;
      }
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _playerState = PlayerState.stopped;
      _onSongCompleted();
      notifyListeners();
    });



    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    // Restore playback state
    await _restorePlaybackState();
  }

  Future<void> playSong(SongModel song, {List<SongModel>? playlist}) async {
    try {
      _playerState = PlayerState.loading;
      notifyListeners();

      // Set up playlist if provided
      if (playlist != null) {
        _currentPlaylist = playlist;
        _currentIndex = playlist.indexWhere((s) => s.id == song.id);
      } else {
        _currentPlaylist = [song];
        _currentIndex = 0;
      }

      _currentSong = song;

      // Stop current playback
      await _audioPlayer.stop();

      // Play new song
      await _audioPlayer.play(DeviceFileSource(song.filePath));

      // Update storage
      await _storageService.incrementPlayCount(song);
      await _savePlaybackState();

      notifyListeners();
    } catch (e) {
      print('Error playing song: $e');
      _playerState = PlayerState.stopped;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    await _savePlaybackState();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    await _savePlaybackState();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
    _currentPosition = Duration.zero;
    _totalDuration = Duration.zero;
    _playerState = PlayerState.stopped;
    await _savePlaybackState();
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_playerState == PlayerState.playing) {
      await pause();
    } else if (_playerState == PlayerState.paused) {
      await resume();
    }
  }

  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
    _currentPosition = position;
    await _savePlaybackState();
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _audioPlayer.setVolume(_volume);
    notifyListeners();
  }

  Future<void> playNext() async {
    if (_currentPlaylist.isEmpty) return;

    int nextIndex;
    if (_isShuffleEnabled) {
      nextIndex = _getRandomIndex();
    } else {
      nextIndex = (_currentIndex + 1) % _currentPlaylist.length;
    }

    if (nextIndex < _currentPlaylist.length) {
      _currentIndex = nextIndex;
      await playSong(_currentPlaylist[nextIndex], playlist: _currentPlaylist);
    }
  }

  Future<void> playPrevious() async {
    if (_currentPlaylist.isEmpty) return;

    int previousIndex;
    if (_isShuffleEnabled) {
      previousIndex = _getRandomIndex();
    } else {
      previousIndex = _currentIndex > 0 ? _currentIndex - 1 : _currentPlaylist.length - 1;
    }

    if (previousIndex >= 0 && previousIndex < _currentPlaylist.length) {
      _currentIndex = previousIndex;
      await playSong(_currentPlaylist[previousIndex], playlist: _currentPlaylist);
    }
  }

  void toggleShuffle() {
    _isShuffleEnabled = !_isShuffleEnabled;
    notifyListeners();
  }

  void toggleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.none:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.none;
        break;
    }
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    if (_currentSong != null) {
      await _storageService.toggleFavorite(_currentSong!);
      notifyListeners();
    }
  }

  int _getRandomIndex() {
    if (_currentPlaylist.length <= 1) return 0;
    int randomIndex;
    do {
      randomIndex = (DateTime.now().millisecondsSinceEpoch % _currentPlaylist.length);
    } while (randomIndex == _currentIndex);
    return randomIndex;
  }

  void _onSongCompleted() {
    switch (_repeatMode) {
      case RepeatMode.one:
        // Replay current song
        if (_currentSong != null) {
          playSong(_currentSong!, playlist: _currentPlaylist);
        }
        break;
      case RepeatMode.all:
      case RepeatMode.none:
        // Play next song
        if (_currentIndex < _currentPlaylist.length - 1 || _repeatMode == RepeatMode.all) {
          playNext();
        } else {
          // End of playlist
          stop();
        }
        break;
    }
  }

  Future<void> _savePlaybackState() async {
    if (_currentSong != null) {
      await _storageService.savePlaybackState(
        songId: _currentSong!.id,
        position: _currentPosition,
        isPlaying: _playerState == PlayerState.playing,
      );
    }
  }

  Future<void> _restorePlaybackState() async {
    final state = await _storageService.getPlaybackState();
    if (state != null) {
      final songId = state['songId'] as String;
      final song = _storageService.songs.firstWhere(
        (s) => s.id == songId,
        orElse: () => SongModel(
          id: '',
          title: '',
          artist: '',
          album: '',
          filePath: '',
          duration: Duration.zero,
        ),
      );

      if (song.id.isNotEmpty) {
        _currentSong = song;
        _currentPosition = state['position'] as Duration;
        
        // Don't auto-play, just restore the state
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}