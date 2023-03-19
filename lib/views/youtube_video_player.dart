import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String videoId;

  const VideoPlayer({Key? key, required this.videoId}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _youtubePlayerController;
  late ValueNotifier<bool> _isPlayerReady;

  @override
  void initState() {
    super.initState();
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    _isPlayerReady = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isPlayerReady,
      builder: (context, isPlayerReady, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: Text(
              "Youtube",
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.black,
          body: YoutubePlayer(
            controller: _youtubePlayerController,
            showVideoProgressIndicator: true,
            onReady: () {
              _isPlayerReady.value = true;
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    _isPlayerReady.dispose();
    super.dispose();
  }
}
