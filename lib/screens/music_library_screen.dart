import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dreamflow/theme.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../models/song_model.dart';

class MusicLibraryScreen extends StatefulWidget {
  const MusicLibraryScreen({super.key});

  @override
  State<MusicLibraryScreen> createState() => _MusicLibraryScreenState();
}

class _MusicLibraryScreenState extends State<MusicLibraryScreen>
    with TickerProviderStateMixin {
  final StorageService _storageService = StorageService();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _listAnimationController;
  
  List<SongModel> _filteredSongs = [];
  bool _isSearching = false;
  String _sortBy = 'title'; // title, artist, date
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _filteredSongs = _storageService.songs;
    _sortSongs();
  }

  void _setupAnimations() {
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchSongs(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredSongs = _storageService.searchSongs(query);
      _sortSongs();
    });
  }

  void _sortSongs() {
    setState(() {
      _filteredSongs.sort((a, b) {
        int result;
        switch (_sortBy) {
          case 'artist':
            result = a.artist.compareTo(b.artist);
            break;
          case 'date':
            result = a.dateAdded.compareTo(b.dateAdded);
            break;
          case 'title':
          default:
            result = a.title.compareTo(b.title);
            break;
        }
        return _sortAscending ? result : -result;
      });
    });
  }

  void _changeSortOption(String sortBy) {
    if (_sortBy == sortBy) {
      setState(() {
        _sortAscending = !_sortAscending;
      });
    } else {
      setState(() {
        _sortBy = sortBy;
        _sortAscending = true;
      });
    }
    _sortSongs();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AudioService(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildSortOptions(),
                Expanded(
                  child: _filteredSongs.isEmpty
                      ? _buildEmptyState()
                      : _buildSongList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.library_music_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Music Library',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${_filteredSongs.length} songs',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          if (_filteredSongs.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: () => _playAllSongs(),
                icon: Icon(
                  Icons.play_arrow_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                tooltip: 'Play All',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _searchSongs,
        decoration: InputDecoration(
          hintText: 'Search songs, artists, albums...',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          suffixIcon: _isSearching
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _searchSongs('');
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(
            'Sort by:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('Title', 'title'),
                  const SizedBox(width: 8),
                  _buildSortChip('Artist', 'artist'),
                  const SizedBox(width: 8),
                  _buildSortChip('Date Added', 'date'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () => _changeSortOption(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                _sortAscending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 14,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isSearching ? Icons.search_off_rounded : Icons.music_off_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _isSearching ? 'No songs found' : 'No music files found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSearching
                ? 'Try searching with different keywords'
                : 'Add music files to your device to see them here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
          if (!_isSearching) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _refreshLibrary(),
              icon: Icon(Icons.refresh_rounded),
              label: Text('Refresh Library'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSongList() {
    return AnimatedBuilder(
      animation: _listAnimationController,
      builder: (context, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: _filteredSongs.length,
          itemBuilder: (context, index) {
            final song = _filteredSongs[index];
            final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _listAnimationController,
                curve: Interval(
                  (index / _filteredSongs.length) * 0.5,
                  ((index + 1) / _filteredSongs.length) * 0.5 + 0.5,
                  curve: Curves.easeOut,
                ),
              ),
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: _buildSongListTile(song, index),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSongListTile(SongModel song, int index) {
    return Consumer<AudioService>(
      builder: (context, audioService, child) {
        final isCurrentSong = audioService.currentSong?.id == song.id;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isCurrentSong
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrentSong
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                  : Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCurrentSong
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.music_note_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  if (isCurrentSong && audioService.isPlaying)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.equalizer_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
            title: Text(
              song.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isCurrentSong
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.artist,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (song.album != 'Unknown Album') ...[
                  const SizedBox(height: 2),
                  Text(
                    song.album,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  song.durationString,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 8),
                if (song.isLiked)
                  Icon(
                    Icons.favorite_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 16,
                  ),
                const SizedBox(width: 8),
                Icon(
                  Icons.more_vert_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  size: 20,
                ),
              ],
            ),
            onTap: () => _playSong(song),
            onLongPress: () => _showSongOptions(song),
          ),
        );
      },
    );
  }

  void _playSong(SongModel song) {
    AudioService().playSong(song, playlist: _filteredSongs);
  }

  void _playAllSongs() {
    if (_filteredSongs.isNotEmpty) {
      AudioService().playSong(_filteredSongs.first, playlist: _filteredSongs);
    }
  }

  Future<void> _refreshLibrary() async {
    setState(() {
      // Show loading state
    });
    
    try {
      await _storageService.scanForMusic();
      setState(() {
        _filteredSongs = _storageService.songs;
        _sortSongs();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning for music: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showSongOptions(SongModel song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(
                song.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: song.isLiked ? Theme.of(context).colorScheme.tertiary : null,
              ),
              title: Text(song.isLiked ? 'Remove from Favorites' : 'Add to Favorites'),
              onTap: () {
                Navigator.pop(context);
                _toggleFavorite(song);
              },
            ),
            ListTile(
              leading: Icon(Icons.play_arrow_rounded),
              title: Text('Play Next'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement play next
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_add_rounded),
              title: Text('Add to Playlist'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add to playlist
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text('Song Details'),
              onTap: () {
                Navigator.pop(context);
                _showSongDetails(song);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(SongModel song) async {
    await _storageService.toggleFavorite(song);
    setState(() {
      // Refresh to show updated favorite status
    });
  }

  void _showSongDetails(SongModel song) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Song Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Title', song.title),
            _buildDetailRow('Artist', song.artist),
            _buildDetailRow('Album', song.album),
            _buildDetailRow('Duration', song.durationString),
            _buildDetailRow('Plays', song.playCount.toString()),
            _buildDetailRow('Added', _formatDate(song.dateAdded)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              text: '\$label: ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}