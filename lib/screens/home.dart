import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sba7o/services/audio_video_service.dart';
import 'package:sba7o/services/connectivity_service.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioVideoService _audioVideoService = AudioVideoService();
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isOffline = false;
  bool _showOfflineBanner = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioVideo();
    _initializeConnectivity();
  }

  Future<void> _initializeAudioVideo() async {
    await _audioVideoService.initializeAll();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeConnectivity() async {
    _connectivityService.initialize();
    await _checkConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityService.checkInternetConnection();
    setState(() {
      _isOffline = !isConnected;
      _showOfflineBanner = _isOffline;
    });
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = results.isNotEmpty && !results.contains(ConnectivityResult.none);
      setState(() {
        _isOffline = !isConnected;
        _showOfflineBanner = _isOffline;
      });
      
      // Hide banner after 3 seconds
      if (_showOfflineBanner) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showOfflineBanner = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/WhatsApp Image 2025-06-25 at 13.27.58_600270e5 (1) (1).jpg',
              fit: BoxFit.cover,
            ),
          ),
          
          // Video Background (if available)
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
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SBA7O',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          if (user != null)
                            Text(
                              'Hi, ${user.email?.split('@')[0] ?? 'Player'}!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(context, '/login');
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Main Content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie Animations
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Lottie.asset(
                              'assets/lottie/Animation - 1750852776663.json',
                              width: 100,
                              height: 100,
                            ),
                            Lottie.asset(
                              'assets/lottie/Animation - 1750852776663 (1).json',
                              width: 100,
                              height: 100,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Center Animation
                        Lottie.asset(
                          'assets/lottie/Animation - 1750851208150 (2).json',
                          width: 200,
                          height: 200,
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Welcome Text
                        const Text(
                          'Welcome to SBA7O!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        Text(
                          _isOffline ? 'Playing Offline Mode' : 'Firebase Connected!',
                          style: TextStyle(
                            color: _isOffline ? Colors.orange : Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Start Game Button
                        SizedBox(
                          width: 300,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/rooms');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            child: const Text(
                              'Start Game',
                              style: TextStyle(
                                color: Color(0xFF1E70FE),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Guest Mode Button
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/rooms');
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Continue as Guest',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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
          ),
          
          // Offline Banner
          if (_showOfflineBanner)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: Colors.orange.withOpacity(0.9),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'No Internet Connection - Continue Offline',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _showOfflineBanner = false;
                        });
                      },
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