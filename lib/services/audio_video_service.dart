import 'package:video_player/video_player.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioVideoService {
  static final AudioVideoService _instance = AudioVideoService._internal();
  factory AudioVideoService() => _instance;
  AudioVideoService._internal();

  VideoPlayerController? _videoPlayerController;
  bool _isVideoInitialized = false;
  bool _isAudioInitialized = false;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  bool get isVideoInitialized => _isVideoInitialized;
  bool get isAudioInitialized => _isAudioInitialized;

  Future<void> initializeVideo() async {
    if (_isVideoInitialized && _videoPlayerController != null) {
      // If already initialized, just ensure it's playing
      if (!_videoPlayerController!.value.isPlaying) {
        await _videoPlayerController!.play();
      }
      return;
    }
    
    try {
      // Dispose any existing controller
      await _videoPlayerController?.dispose();
      
      _videoPlayerController = VideoPlayerController.asset('assets/video/background.mp4');
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.setLooping(true);
      await _videoPlayerController!.setVolume(0.0); // Mute the video
      await _videoPlayerController!.play();
      _isVideoInitialized = true;
      print('Video initialized successfully');
    } catch (e) {
      print('Error initializing video: $e');
      _isVideoInitialized = false;
    }
  }

  Future<void> initializeAudio() async {
    if (_isAudioInitialized) return; // Already initialized
    
    try {
      FlameAudio.bgm.initialize();
      await FlameAudio.bgm.play('energy-sport-347786.mp3', volume: 0.5);
      _isAudioInitialized = true;
      print('Audio initialized successfully');
    } catch (e) {
      print('Error initializing audio: $e');
      _isAudioInitialized = false;
    }
  }

  Future<void> initializeAll() async {
    await initializeVideo();
    await initializeAudio();
  }

  void pauseVideo() {
    _videoPlayerController?.pause();
  }

  void resumeVideo() {
    _videoPlayerController?.play();
  }

  void stopAudio() {
    FlameAudio.bgm.stop();
    _isAudioInitialized = false;
  }

  Future<void> dispose() async {
    await _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _isVideoInitialized = false;
    stopAudio();
  }
} 