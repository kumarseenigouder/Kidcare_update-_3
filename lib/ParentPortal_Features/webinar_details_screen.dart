import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';

// class WebinarDetailsScreen extends StatelessWidget {
//   const WebinarDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final GoRouterState state = GoRouterState.of(context);
//     final title = state.uri.queryParameters['title'] ?? 'Webinar';
//     final doctor = state.uri.queryParameters['doctor'] ?? 'Unknown Doctor';

//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: Center(child: Text("Hosted by $doctor")),
//     );
//   }
// }

class WebinarDetailsScreen extends StatefulWidget {
  const WebinarDetailsScreen({super.key});

  @override
  State<WebinarDetailsScreen> createState() => _WebinarDetailsScreenState();
}

class _WebinarDetailsScreenState extends State<WebinarDetailsScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // ✅ Replace with valid playable link
      )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vaccination Webinar')),
      body: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
              : const Center(child: CircularProgressIndicator()),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Vaccination Guidelines by Dr. Sara Imran\n\nLearn about the latest immunization schedule, vaccine safety, and parental tips.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
