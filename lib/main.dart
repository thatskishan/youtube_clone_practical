import 'package:flutter/material.dart';
import 'package:youtube_clone/views/youtube_search.dart';

void main() => runApp(const YoutubeApp());

class YoutubeApp extends StatelessWidget {
  const YoutubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SearchPage(),
    );
  }
}
