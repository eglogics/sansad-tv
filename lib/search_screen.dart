import "dart:convert";
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:sansadtv_app/constants.dart";
import "package:sansadtv_app/themes.dart";
import "package:sansadtv_app/videos_list.dart";
import "package:html_unescape/html_unescape.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> videoID = [];
  List<String> videoThumbnailUrl = [];
  List<String> videoTitle = [];
  List<String> videoDate = [];
  late TextEditingController textEditingController;
  bool fetchStatus = true;
  var unescape = HtmlUnescape();
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                controller: textEditingController,
                onSubmitted: (value) {
                  setState(() => fetchStatus = true);
                  textEditingController.text = textEditingController.text.trim();
                  String query = textEditingController.text;
                  searchQuery(query);
                },
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Videos',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  prefixIconColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
            const SizedBox(
              height: 0,
            ),
            Expanded(
              child: Container(
                decoration: pageCardDecoration(),
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: textEditingController.text.trim() == ""
                    ? Center(
                        child: Text(
                          'Start typing to\nsearch for videos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : (fetchStatus
                        ? SingleChildScrollView(
                            child: VideosList(
                              videoID: videoID,
                              videoThumbnailUrl: videoThumbnailUrl,
                              videoTitle: videoTitle,
                              videoDate: videoDate,
                            ),
                          )
                        : const NetworkError()),
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
    if (query == "") return;
    String encodedQuery = Uri.encodeComponent(query);
    const fields = 'items(id,snippet(title,thumbnails,publishedAt))';
    final String apiUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&fields=$fields&q=$encodedQuery&type=video&maxResults=$searchVideosLimit&key=${getApiKey()}';
    try {
      var response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) {
        throw Exception();
      }
      List bodyItems = jsonDecode(response.body)['items'];

      setState(
        () {
          for (var element in bodyItems) {
            videoID.add(element['id']['videoId']);
            videoTitle.add(unescape.convert(element['snippet']['title']));
            videoDate.add(DateFormat.yMMMMd().format(DateTime.parse(element['snippet']['publishedAt'])));
            Map<String, dynamic> thumbnails = element['snippet']['thumbnails'];
            if (thumbnails.containsKey('high')) {
              videoThumbnailUrl.add(thumbnails['high']['url']);
            } else if (thumbnails.containsKey('medium')) {
              videoThumbnailUrl.add(thumbnails['medium']['url']);
            } else {
              videoThumbnailUrl.add(thumbnails['default']['url']);
            }
          }
        },
      );
    } catch (e) {
      setState(() {
        fetchStatus = false;
      });
    }
  }
}

class NetworkError extends StatelessWidget {
  const NetworkError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 50.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Please check your internet\nconnection and try again!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
