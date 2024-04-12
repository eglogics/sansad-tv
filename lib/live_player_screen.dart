import "package:flutter/material.dart";
import "package:lecle_yoyo_player/lecle_yoyo_player.dart";

import "package:sansadtv_app/constants.dart";
import "package:sansadtv_app/search_screen.dart";
import "package:sansadtv_app/themes.dart";

class LivePlayerScreen extends StatefulWidget {
  const LivePlayerScreen({super.key, required this.livestreamUrl, required this.liveStreamTitle});

  final String livestreamUrl;
  final String liveStreamTitle;
  @override
  State<LivePlayerScreen> createState() => _LivePlayerScreenState();
}

class _LivePlayerScreenState extends State<LivePlayerScreen> {
  bool fetchStatus = true;
  bool fullscreen = false;

  @override
  void initState() {
    super.initState();
    print("RanjeetTest===========>");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: fullscreen == false
          ? AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      )
          : null,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var width = MediaQuery.of(context).size.width;
            var height = MediaQuery.of(context).size.height;
            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: fullscreen==true?1.30:10/8,
                      child: YoYoPlayer(
                        url: widget.livestreamUrl,
                          onFullScreen: (t) {
                            setState(() {
                              fullscreen = t;
                            });
                          },
                          videoStyle: const VideoStyle(
                            playIcon: Icon(Icons.play_arrow),
                            pauseIcon: Icon(Icons.pause),
                            fullscreenIcon: Icon(Icons.fullscreen),
                            forwardIcon: Icon(Icons.skip_next),
                            backwardIcon: Icon(Icons.skip_previous),
                          )
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: fetchStatus ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.liveStreamTitle,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 80,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[850],
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            const Icon(
                                              Icons.circle,
                                              size: 16,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "LIVE",
                                              style: TextStyle(
                                                color: Colors.grey[100],
                                                fontSize: 15,
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(aboutText),
                              ],
                            )
                          : const NetworkError(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
