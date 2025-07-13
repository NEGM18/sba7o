import 'package:flutter/material.dart';
import 'package:sba7o/screens/yourrooms.dart';
import 'package:video_player/video_player.dart';
import 'package:sba7o/services/audio_video_service.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  final AudioVideoService _audioVideoService = AudioVideoService();

  @override
  void initState() {
    super.initState();
    _initializeAudioVideo();
  }

  Future<void> _initializeAudioVideo() async {
    await _audioVideoService.initializeAll();
    // Force rebuild to show video
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Don't dispose here - let the service manage it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Game modes'),
        backgroundColor: const Color.fromARGB(255, 44, 61, 75),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Video Background
          if (_audioVideoService.isVideoInitialized && _audioVideoService.videoPlayerController != null)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _audioVideoService.videoPlayerController!.value.size.width,
                  height: _audioVideoService.videoPlayerController!.value.size.height,
                  child: VideoPlayer(_audioVideoService.videoPlayerController!),
                ),
              ),
            ),
          
          // Content overlay
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Your Rooms Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const YourRooms()),
                        );
                        print('Your Rooms button pressed');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Your Rooms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Quick Game Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to quick game
                        print('Quick Game button pressed');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Quick Game',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}