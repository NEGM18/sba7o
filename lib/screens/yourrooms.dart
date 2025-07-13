import 'package:flutter/material.dart';
import 'package:sba7o/screens/careatenew.dart';
import 'package:video_player/video_player.dart';
import 'package:sba7o/services/audio_video_service.dart';

class YourRooms extends StatefulWidget {
  const YourRooms({super.key});

  @override
  State<YourRooms> createState() => _YourRoomsState();
}

class _YourRoomsState extends State<YourRooms>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioVideoService _audioVideoService = AudioVideoService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
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
    _controller.dispose();
    // Don't dispose audio/video here - let the service manage it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      
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
                  // Title
                  const Text(
                    'Your Rooms',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Example Room Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          print('Room card pressed');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Room Number
                              Text(
                                'Room #001',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue[700],
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Room Name
                              const Text(
                                'Football Champions League',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Questions Category
                              Text(
                                'Sports & Football',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Add New Room Button
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
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Careatenew()),
                        );
                        print('Create new room pressed');
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Create New Room',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
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