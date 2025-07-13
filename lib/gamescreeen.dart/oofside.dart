import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // Added video_player import
import 'package:sba7o/services/audio_video_service.dart'; // Added AudioVideoService import

class offside extends StatefulWidget {
  const offside({super.key});

  @override
  State<offside> createState() => _offsideState();
}

class _offsideState extends State<offside> with SingleTickerProviderStateMixin { // Added SingleTickerProviderStateMixin
  int n = 0;
  final TextEditingController nController = TextEditingController();
  List<TextEditingController> questionControllers = [];

  final AudioVideoService _audioVideoService = AudioVideoService(); // Moved AudioVideoService instance here
  late AnimationController _controller; // Added AnimationController here

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this); // Initialized controller here
    _initializeAudioVideo(); // Initialized audio/video here
  }

  // Initializes audio and video services.
  Future<void> _initializeAudioVideo() async {
    await _audioVideoService.initializeAll();
    if (mounted) {
      setState(() {});
    }
  }

  void updateQuestions() {
    final parsed = int.tryParse(nController.text);
    if (parsed != null && parsed > 0) {
      setState(() {
        n = parsed;
        // Adjust the list of controllers
        if (questionControllers.length < n) {
          questionControllers.addAll(
            List.generate(n - questionControllers.length, (i) => TextEditingController()),
          );
        } else if (questionControllers.length > n) {
          // Dispose controllers that are no longer needed
          for (int i = n; i < questionControllers.length; i++) {
            questionControllers[i].dispose();
          }
          questionControllers = questionControllers.sublist(0, n);
        }
      });
    }
  }

  @override
  void dispose() {
    nController.dispose();
    for (var c in questionControllers) {
      c.dispose();
    }
    _controller.dispose(); // Dispose the AnimationController
    // Only dispose AudioVideoService if it's explicitly managed by this widget and not a global service
    // If AudioVideoService is intended to persist across screens, do not dispose it here.
    // Based on previous code, it seems like a shared service, so no disposal here for the service itself.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('offside')),
      body: Stack( // Changed to Stack to allow video background
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('عدد الأسئلة:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)), // Added white color for visibility
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'أدخل عدد الأسئلة',
                            hintStyle: TextStyle(color: Colors.white70), // Added hint style
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white), // Added text style
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: updateQuestions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.8), // Styled button
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('تأكيد'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (n > 0)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: n,
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: questionControllers[i],
                          decoration: InputDecoration(
                            labelText: 'السؤال رقم ${i + 1}',
                            labelStyle: const TextStyle(color: Colors.white), // Added label style
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white), // Added text style
                        ),
                      ),
                    ),
                  // Add a button to submit questions
                  if (n > 0) // Only show the button if questions are being displayed
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Collect all the question texts
                            List<String> questions = questionControllers.map((controller) => controller.text).toList();
                            print('Submitted Questions: $questions');
                            // You can add further logic here, e.g., send to a service, validate, etc.
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.withOpacity(0.8), // Styled button
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Submit Questions',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
