import "dart:convert";
import "dart:developer";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:html_unescape/html_unescape.dart";
import "package:intl/intl.dart";
import "package:sansadtv_app/constants.dart";
import 'package:http/http.dart' as http;
import "package:sansadtv_app/search_screen.dart";
import "package:sansadtv_app/static_data_pages.dart";
import "package:sansadtv_app/themes.dart";
import "package:sansadtv_app/utils/method.dart";
import "package:sansadtv_app/utils/video_list_new.dart";
import "model/recent_show_model.dart";

class RecentScreen extends StatefulWidget {
  const RecentScreen({super.key});

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  late List<String> videoID = [];
  late List<String> videoThumbnailUrl = [];
  late List<String> videoTitle = [];
  late List<String> videoDate = [];
  late List<String> livestreamTitle = [];
  late List<String> livestreamUrl = [];
  Future<dynamic>? mRecentShowVideoList;

  bool lsfetchStatus = false;
  bool videofetchStatus = true;
  var unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    fetchLS();
    fetchVideos();
    mRecentShowVideoList=validateGetVideoList();
    mRecentShowVideoList!.then((value){
      print("==============>"+value.recentShows[0].title);
      print("==============>"+value.recentShows[0].Img);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Center(
                  child: Image.asset(
                    "images/logo-sansad.png",
                    height: 120.0,
                  ),
                ),
              ),
              const SizedBox(),
              const Text(
                "Welcome to",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const Text(
                "Sansad TV",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                decoration: pageCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Live Now',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: LivestreamCarousel(livestreamUrl: livestreamUrl, livestreamTitle: livestreamTitle),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Text(
                        'Follow us on',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 12.0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: listDecoration(),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SocialMediaLogo(imageAsset: "images/fb-logo.png", url: fbUrl),
                            SocialMediaLogo(imageAsset: "images/insta-logo.png", url: instaUrl),
                            SocialMediaLogo(imageAsset: "images/koo-logo.png", url: kooUrl),
                            SocialMediaLogo(imageAsset: "images/X-logo.png", url: xUrl),
                            SocialMediaLogo(imageAsset: "images/yt-logo.png", url: ytUrl),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Text(
                        'Recent Videos',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: mRecentShowVideoList,
                        builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) =>
                        snapshot.hasData ? VideosListNew(recentShows: snapshot.data.recentShows,)/*VideosList(
                          videoID: videoID,
                          videoThumbnailUrl: videoThumbnailUrl,
                          videoTitle: videoTitle,
                          videoDate: videoDate,
                        )*/: const  Padding(
                          padding: EdgeInsets.symmetric(vertical: 150.0),
                          child: NetworkError(),
                        ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchLS() async {
    try {
      final lsResponse = await http.head(Uri.parse(lsLiveUrl));
      if (lsResponse.statusCode == 200) {
        livestreamTitle.add("Sansad TV LS");
        livestreamUrl.add(lsLiveUrl);
      }
      final rsResponse = await http.head(Uri.parse(rsLiveUrl));
      if (rsResponse.statusCode == 200) {
        livestreamTitle.add("Sansad TV RS");
        livestreamUrl.add(rsLiveUrl);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> fetchVideos() async {
    const fields = 'items(id,snippet(title,thumbnails, publishedAt))';
    String apiUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&fields=$fields&maxResults=$recentVideosLimit&type=video&order=date&key=${getApiKey()}';
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode != 200) {
        log(response.body);
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
        videofetchStatus = false;
      });

      log(e.toString());
    }
  }

  Future<Recentshowmodel?> validateGetVideoList() async {
     bool internet = true;
    internet = await Method.check();
    if (internet) {
      final response = await http.get(Uri.parse('https://sansadtv.nic.in/wp-json/wp/v2/recent_shows'));
      print(response.body.toString());
      Map mapRes = json.decode(response.body);
      if (mapRes['Status'] == '200') {
        return Recentshowmodel.fromJson(mapRes);
      } else {
        return Recentshowmodel.fromJson(mapRes);
      }
    }
  }

}
