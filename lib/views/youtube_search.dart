import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_clone/models/globals.dart';
import 'package:youtube_clone/views/search_history.dart';
import 'package:youtube_clone/views/youtube_video_player.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

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
        leading: SizedBox(
          height: 55,
          width: 55,
          child: Image.asset("asses/images/logo.png"),
        ),
        title: Text(
          "Youtube",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notification_add_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.cast,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchHistory(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          const CircleAvatar(
            backgroundImage: AssetImage("asses/images/dp.jpg"),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
                    Globals.searchResults.add(query);
                    print(Globals.searchResults);
                    _searchResults = items;
                  });
                },
              ),
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
                return GestureDetector(
                  onTap: () {
                    // Navigate to the video player page when a video is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayer(videoId: videoId),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(thumbnail),
                            ),
                            title: Text(
                              title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              description,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
