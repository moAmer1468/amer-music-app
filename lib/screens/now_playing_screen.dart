import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dreamflow/theme.dart';
import '../services/audio_service.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with TickerProviderStateMixin {
  late AnimationController _albumArtController;
  late AnimationController _controlsController;
  late Animation<double> _albumArtAnimation;
  late Animation<double> _controlsAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _albumArtController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controlsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _albumArtAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _albumArtController, curve: Curves.easeOut),
    );
    _controlsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controlsController, curve: Curves.easeOut),
    );

    _albumArtController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _controlsController.forward();
    });
  }

  @override
  void dispose() {
    _albumArtController.dispose();
    _controlsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AudioService(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Consumer<AudioService>(
              builder: (context, audioService, child) {
                final currentSong = audioService.currentSong;
                if (currentSong == null) {
                  return _buildNoSongPlaying();
                }

                return Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Spacer(),
                            _buildAlbumArt(currentSong),
                            const SizedBox(height: 48),
                            _buildSongInfo(currentSong),
                            const SizedBox(height: 32),
                            _buildProgressSection(audioService),
                            const SizedBox(height: 48),
                            _buildControlButtons(audioService),
                            const SizedBox(height: 32),
                            _buildSecondaryControls(audioService),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoSongPlaying() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No song playing',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a song to start playing',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.library_music_rounded),
            label: Text('Browse Music'),
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
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Now Playing',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => _showOptionsBottomSheet(),
              icon: Icon(
                Icons.more_vert_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(dynamic currentSong) {
    return ScaleTransition(
      scale: _albumArtAnimation,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.music_note_rounded,
                size: 80,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongInfo(dynamic currentSong) {
    return FadeTransition(
      opacity: _controlsAnimation,
      child: Column(
        children: [
          Text(
            currentSong.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            currentSong.artist,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            currentSong.album,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(AudioService audioService) {
    return FadeTransition(
      opacity: _controlsAnimation,
      child: Column(
        children: [
          // Progress bar
          Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                thumbColor: Theme.of(context).colorScheme.primary,
              ),
              child: Slider(
                value: audioService.progress.clamp(0.0, 1.0),
                onChanged: (value) {
                  final position = Duration(
                    milliseconds: (value * audioService.totalDuration.inMilliseconds).round(),
                  );
                  audioService.seekTo(position);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Time labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(audioService.currentPosition),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDuration(audioService.totalDuration),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(AudioService audioService) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(_controlsAnimation),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.skip_previous_rounded,
            size: 40,
            onPressed: () => audioService.playPrevious(),
            isPrimary: false,
          ),
          _buildPlayPauseButton(audioService),
          _buildControlButton(
            icon: Icons.skip_next_rounded,
            size: 40,
            onPressed: () => audioService.playNext(),
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required double size,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(isPrimary ? 32 : 24),
        border: Border.all(
          color: isPrimary
              ? Colors.transparent
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPrimary
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.shadow)
                .withOpacity(0.2),
            blurRadius: isPrimary ? 20 : 8,
            offset: Offset(0, isPrimary ? 8 : 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isPrimary
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          size: size,
        ),
        iconSize: size,
        padding: EdgeInsets.all(isPrimary ? 16 : 12),
      ),
    );
  }

  Widget _buildPlayPauseButton(AudioService audioService) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => audioService.togglePlayPause(),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            audioService.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            key: ValueKey(audioService.isPlaying),
            color: Theme.of(context).colorScheme.onPrimary,
            size: 48,
          ),
        ),
        iconSize: 48,
        padding: const EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildSecondaryControls(AudioService audioService) {
    return FadeTransition(
      opacity: _controlsAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSecondaryButton(
            icon: audioService.isShuffleEnabled ? Icons.shuffle_on_rounded : Icons.shuffle_rounded,
            isActive: audioService.isShuffleEnabled,
            onPressed: () => audioService.toggleShuffle(),
          ),
          _buildSecondaryButton(
            icon: audioService.currentSong?.isLiked == true 
                ? Icons.favorite_rounded 
                : Icons.favorite_border_rounded,
            isActive: audioService.currentSong?.isLiked == true,
            onPressed: () => audioService.toggleFavorite(),
          ),
          _buildSecondaryButton(
            icon: _getRepeatIcon(audioService.repeatMode),
            isActive: audioService.repeatMode != RepeatMode.none,
            onPressed: () => audioService.toggleRepeat(),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          size: 24,
        ),
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  IconData _getRepeatIcon(RepeatMode repeatMode) {
    switch (repeatMode) {
      case RepeatMode.none:
        return Icons.repeat_rounded;
      case RepeatMode.all:
        return Icons.repeat_on_rounded;
      case RepeatMode.one:
        return Icons.repeat_one_rounded;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showOptionsBottomSheet() {
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
              leading: Icon(Icons.playlist_add_rounded),
              title: Text('Add to Playlist'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add to playlist
              },
            ),
            ListTile(
              leading: Icon(Icons.share_rounded),
              title: Text('Share Song'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text('Song Info'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement song info
              },
            ),
          ],
        ),
      ),
    );
  }
}