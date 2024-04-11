import "dart:convert";
import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_linkify/flutter_linkify.dart";
import "package:html_unescape/html_unescape.dart";
import "package:sansadtv_app/constants.dart";
import "package:sansadtv_app/search_screen.dart";
import "package:sansadtv_app/themes.dart";

import 'package:http/http.dart' as http;
import "package:intl/intl.dart";
import "package:url_launcher/url_launcher.dart";
import "package:youtube_player_iframe/youtube_player_iframe.dart";

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.videoID});

  final String videoID;
  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool fetchStatus = true;
  var unescape = HtmlUnescape();

  String title = "";
  String description = "";
  String publishedAtDate = "";
  String publishedAtTime = "";

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoID,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: false),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool isWideScreen = constraints.maxWidth > 1000;

              return Container(
                decoration: pageCardDecoration(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 200.0 : 20.0, vertical: 20.0),
                        child: IntrinsicWidth(
                          child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 8.0,
                                )
                              ],
                            ),
                            child: YoutubePlayer(
                              controller: controller,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: fetchStatus
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    publishedAtDate,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    publishedAtTime,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Linkify(
                                    onOpen: (LinkableElement link) async {
                                      if (!await launchUrl(Uri.parse(link.url))) {
                                        throw Exception('Could not launch $link.url');
                                      }
                                    },
                                    text: description,
                                  ),
                                ],
                              )
                            : const NetworkError(),
                      ),
                      const SizedBox(height: 350.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void fetchDetails() async {
    const fields = 'items(id,snippet(title,description,publishedAt))';
    final apiUrl = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&field=$fields&id=${widget.videoID}&key=${getApiKey()}&maxResults=1';
    try {
      var response = await http.get(Uri.parse(apiUrl));
      var encodedBody = jsonDecode(response.body);
      Map<String, dynamic> body = encodedBody;

      if (response.statusCode != 200 || !body.containsKey('items')) {
        throw Exception();
      }
      final data = body['items'];
      final details = data[0]['snippet'];
      DateTime dateTime = DateTime.parse(details['publishedAt']);
      setState(() {
        title = unescape.convert(details['title']);
        description = unescape.convert(details['description']);
        publishedAtDate = DateFormat.yMMMMd().format(dateTime);
        publishedAtTime = DateFormat.jm().format(dateTime);
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        fetchStatus = false;
      });
    }
  }
}
