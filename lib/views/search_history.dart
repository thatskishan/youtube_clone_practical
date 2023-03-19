import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_clone/models/globals.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Globals.searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  void _saveSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('search_history', Globals.searchHistory);
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      Globals.searchHistory.insert(0, query);
    });
    _saveSearchHistory();
  }

  void _clearSearchHistory() {
    setState(() {
      Globals.searchHistory.clear();
    });
    _saveSearchHistory();
  }

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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.clear_all,
              color: Colors.white,
            ),
            onPressed: _clearSearchHistory,
          ),
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Globals.searchHistory.length,
              itemBuilder: (context, index) {
                final searchQuery = Globals.searchHistory[index];
                return ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  title: Text(
                    searchQuery,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.call_made_outlined,
                    color: Colors.white,
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
