import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_clone/models/globals.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search History",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: Globals.searchResults
            .map(
              (e) => ListTile(
                leading: const Icon(
                  Icons.history,
                  color: Colors.white,
                ),
                title: Text(
                  e,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
                trailing: const Icon(
                  Icons.call_made_outlined,
                  color: Colors.white,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
