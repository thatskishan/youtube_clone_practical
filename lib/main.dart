import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() => runApp(YoutubeApp());

class YoutubeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.slow_motion_video_outlined,
          color: Colors.red,
        ),
        title: Text(
          "Youtube",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 10,
                bottom: 5,
                right: 10,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  )),
              child: TextField(
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (query) async {
                  // Perform the search query
                  final response = await http.get(
                    Uri.https(
                      'www.googleapis.com',
                      '/youtube/v3/search',
                      {
                        'part': 'snippet',
                        'q': query,
                        'type': 'video',
                        'maxResults': '5',
                        'key': 'AIzaSyCMtXP_hC_mQT2L9EG_dAh6ieqpiztbmKI',
                      },
                    ),
                  );

                  // Parse the JSON response and update the state with the search results
                  final Map<String, dynamic> data = jsonDecode(response.body);
                  final List<dynamic> items = data['items'];
                  setState(() {
                    _searchResults = items;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final video = _searchResults[index];
                  final videoId = video['id']['videoId'];
                  final title = video['snippet']['title'];
                  final description = video['snippet']['description'];
                  final thumbnail =
                      video['snippet']['thumbnails']['default']['url'];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: Image.network(thumbnail),
                      title: Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                      // subtitle: Text(
                      //   description,
                      //   style: GoogleFonts.poppins(
                      //     color: Colors.white,
                      //   ),
                      // ),
                      onTap: () {
                        // Navigate to the video player page when a video is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayer(videoId: videoId),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      flags: YoutubePlayerFlags(
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
        return YoutubePlayer(
          controller: _youtubePlayerController,
          showVideoProgressIndicator: true,
          onReady: () {
            _isPlayerReady.value = true;
          },
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
