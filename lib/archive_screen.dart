import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sansadtv_app/constants.dart';
import 'package:sansadtv_app/search_screen.dart';
import 'package:sansadtv_app/themes.dart';
import 'package:sansadtv_app/videos_list.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key, required this.query});

  final String query;

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<String> videoID = [];
  List<String> videoThumbnailUrl = [];
  List<String> videoTitle = [];
  List<String> videoDate = [];
  var unescape = HtmlUnescape();
  bool fetchStatus = true;

  @override
  void initState() {
    super.initState();
    searchQuery(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                widget.query,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      offset: Offset(
                        4.0,
                        4.0,
                      ),
                      color: Colors.black54,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                decoration: pageCardDecoration(),
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: fetchStatus
                    ? SingleChildScrollView(
                        child: VideosList(
                          videoID: videoID,
                          videoThumbnailUrl: videoThumbnailUrl,
                          videoTitle: videoTitle,
                          videoDate: videoDate,
                        ),
                      )
                    : const NetworkError(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchQuery(String query) async {
    setState(() {
      videoID.clear();
      videoThumbnailUrl.clear();
      videoDate.clear();
    });

    if (query.contains("Corner")) {
      query = query.substring(0, query.length - "'s Corner".length);
    }

    if (searchKeywords.containsKey(query)) query = searchKeywords[query] as String;
    String encodedQuery = Uri.encodeComponent(query);
    const fields = 'items(id,snippet(title,thumbnails,publishedAt))';
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&fields=$fields&q=intitle:"$encodedQuery"&type=video&maxResults=$searchVideosLimit&key=${getApiKey()}&order=date';
    final String apiUrlBackup =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&fields=$fields&q=$encodedQuery&type=video&maxResults=$searchVideosLimit&key=${getApiKey()}&order=date';

    try {
      var response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 20));
      List bodyItems = jsonDecode(response.body)['items'];

      if (bodyItems.length <= 3) {
        response = await http.get(Uri.parse(apiUrlBackup)).timeout(const Duration(seconds: 20));
        bodyItems = jsonDecode(response.body)['items'];
      }
      setState(() {
        for (var element in bodyItems) {
          videoID.add(element['id']['videoId']);
          videoTitle.add(unescape.convert(element['snippet']['title']));
          videoDate.add(DateFormat.yMMMMd().format(DateTime.parse(element['snippet']['publishedAt'])));
          Map<String, dynamic> thumbnails = element['snippet']['thumbnails'];
          videoThumbnailUrl.add(thumbnails.containsKey('high')
              ? thumbnails['high']['url']
              : thumbnails.containsKey('medium')
                  ? thumbnails['medium']['url']
                  : thumbnails['default']['url']);
        }
      });
    } catch (e) {
      setState(() {
        fetchStatus = false;
      });
    }
  }
}
