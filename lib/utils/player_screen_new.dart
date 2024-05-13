import "dart:convert";
import "dart:developer";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_linkify/flutter_linkify.dart";
import "package:html_unescape/html_unescape.dart";
import "package:sansadtv_app/constants.dart";
import "package:sansadtv_app/search_screen.dart";
import "package:sansadtv_app/themes.dart";
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

import 'package:http/http.dart' as http;
import "package:url_launcher/url_launcher.dart";
import "package:youtube_player_flutter/youtube_player_flutter.dart";


class PlayerScreenNew extends StatefulWidget {
  const PlayerScreenNew(
      {super.key,
      required this.videoID,
      required this.title,
      required this.description,
      required this.publishedAtDate,
      required this.publishedAtTime});

  final String videoID;
  final String title;
  final String description;
  final String publishedAtDate;
  final String publishedAtTime;

  @override
  State<PlayerScreenNew> createState() => _PlayerScreenNewState();
}

class _PlayerScreenNewState extends State<PlayerScreenNew> {
  bool fetchStatus = true;
  var unescape = HtmlUnescape();

  String mIframeUrl = "";
  var mcontroller;

  String _buildIframeUrl(String iframeUrl) {
    String encodedHtmlContent = Uri.dataFromString(
      iframeUrl,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();

    return encodedHtmlContent;
  }

  String extractUrlFromIframe(String htmlString) {
    dom.Document document = parser.parse(htmlString);
    dom.Element? iframeElement = document.querySelector('iframe');
    String? src = iframeElement?.attributes['src'];

    return src ?? '';
  }


  @override
  void initState() {
    super.initState();
    print("RanjeetTest111============> " + extractUrlFromIframe(widget.videoID));
    List<String> parts = extractUrlFromIframe(widget.videoID).split("https://www.youtube.com/embed/");;
    mIframeUrl=parts[1];
    print("RanjeetTest222============> ${parts[1]}");


    //fetchDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* var controller = YoutubePlayerController.fromVideoId(
      videoId: "3ghglye8Fh0?si=l2IXdEAL6erEkk1r",
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );*/

    var controller = YoutubePlayerController(
      initialVideoId: mIframeUrl,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
            //  print("RanjeetTest===========>"+"Portrait");
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    decoration: pageCardDecoration(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 90.0,
                            color: Theme.of(context).primaryColor,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 35, 0, 0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                      
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                YoutubePlayer(
                                    aspectRatio: 16 / 9, controller: controller),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: fetchStatus
                                      ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.title,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.publishedAtDate,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.publishedAtTime,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Linkify(
                                        onOpen: (LinkableElement link) async {
                                          if (!await launchUrl(
                                              Uri.parse(link.url))) {
                                            throw Exception(
                                                'Could not launch $link.url');
                                          }
                                        },
                                        text: widget.description,
                                      ),
                                    ],
                                  )
                                      : const NetworkError(),
                                ),
                                const SizedBox(height: 350.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }else {
              //print("RanjeetTest===========>"+"LandScape");
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    decoration: pageCardDecoration(),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 350,//(MediaQuery.of(context).size.width)/16*6,
                            child: YoutubePlayer(
                                aspectRatio: 16 / 9,
                                controller: controller,
                              width: 320,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: fetchStatus
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.publishedAtDate,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.publishedAtTime,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Linkify(
                                  onOpen: (LinkableElement link) async {
                                    if (!await launchUrl(
                                        Uri.parse(link.url))) {
                                      throw Exception(
                                          'Could not launch $link.url');
                                    }
                                  },
                                  text: widget.description,
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
              );
            }// else show the landscape one
          }),

        ));
  }

  void fetchDetails() async {
    const fields = 'items(id,snippet(title,description,publishedAt))';
    final apiUrl =
        'https://www.googleapis.com/youtube/v3/videos?part=snippet&field=$fields&id=${"3ghglye8Fh0?si=l2IXdEAL6erEkk1r"}&key=${getApiKey()}&maxResults=1';
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
        //title = unescape.convert(details['title']);
        //description = unescape.convert(details['description']);
        //publishedAtDate = DateFormat.yMMMMd().format(dateTime);
        //publishedAtTime = DateFormat.jm().format(dateTime);
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        fetchStatus = false;
      });
    }
  }
}
