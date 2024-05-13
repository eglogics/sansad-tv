import 'package:flutter/material.dart';
import 'package:sansadtv_app/live_player_screen.dart';
import 'package:sansadtv_app/player_screen.dart';
import 'package:sansadtv_app/utils/player_screen_new.dart';
import '../model/recent_show_model.dart';

class VideosListNew extends StatefulWidget {
  const VideosListNew({
    super.key,
    required this.recentShows,
  });

  final List<RecentShows> recentShows;

  @override
  State<VideosListNew> createState() => _VideosListNewState();
}

class _VideosListNewState extends State<VideosListNew> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.recentShows.length,
            itemBuilder: (context, index) {
              return VideoCard1(
                videoID: widget.recentShows[index].episode_iframe_video,
                videoThumbnailUrl: widget.recentShows[index].Img,
                videoTitle: widget.recentShows[index].title,
                videoDate: widget.recentShows[index].fullDesc,
              );
            },
          );
        } else {
          return SizedBox(
            height: 260,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3.0,
                    ),
                    child: ScrollableVideoCard(
                      videoID: widget.recentShows[index].episode_iframe_video,
                      videoThumbnailUrl: widget.recentShows[index].Img,
                      videoTitle: widget.recentShows[index].title,
                      videoDate: widget.recentShows[index].shortDisc,
                    ),
                  );
                },
                itemCount: widget.recentShows.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          );
        }
      },
    );
  }
}

class LivestreamCarousel extends StatefulWidget {
  const LivestreamCarousel({
    super.key,
    required this.livestreamUrl,
    required this.livestreamTitle,
  });

  final List<String> livestreamUrl;
  final List<String> livestreamTitle;

  @override
  LivestreamCarouselState createState() => LivestreamCarouselState();
}

class LivestreamCarouselState extends State<LivestreamCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          return _buildPageView();
        } else {
          return _buildScrollableRow();
        }
      },
    );
  }

  Widget _buildPageView() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.livestreamTitle.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LivePlayerScreen(
                        liveStreamTitle: widget.livestreamTitle[index],
                        livestreamUrl: widget.livestreamUrl[index],
                      ),
                    ),
                  );
                },
                child: LSCard(
                  livestreamUrl: widget.livestreamUrl[index],
                  livestreamThumbnailUrl: "https://sansadtv.nic.in/wp-content/uploads/2021/09/Iconic-Speeches-3.jpg",
                  livestreamTitle: widget.livestreamTitle[index],
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildDotsIndicator(),
      ],
    );
  }

  Widget _buildScrollableRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.livestreamTitle.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LivePlayerScreen(
                    liveStreamTitle: widget.livestreamUrl[index],
                    livestreamUrl: widget.livestreamUrl[index],
                  ),
                ),
              );
            },
            child: ScrollableLSCard(
                livestreamUrl: widget.livestreamUrl[index], livestreamThumbnailUrl: "https://sansadtv.nic.in/wp-content/uploads/2021/09/Iconic-Speeches-3.jpg", livestreamTitle: widget.livestreamTitle[index]),
          );
        },
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.livestreamTitle.length,
            (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}

class ScrollableLSCard extends StatelessWidget {
  const ScrollableLSCard({super.key, required this.livestreamUrl, required this.livestreamThumbnailUrl, required this.livestreamTitle});

  final String livestreamUrl;
  final String livestreamThumbnailUrl;
  final String livestreamTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(livestreamThumbnailUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6.0,
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 12,
              right: 17,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$livestreamTitle | Live",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollableVideoCard extends StatelessWidget {
  const ScrollableVideoCard({super.key, required this.videoID, required this.videoThumbnailUrl, required this.videoTitle, this.videoDate = ""});

  final String videoID;
  final String videoThumbnailUrl;
  final String videoTitle;
  final String videoDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(videoThumbnailUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6.0,
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 12,
              right: 17,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  videoDate != ""
                      ? Text(
                    videoDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class VideoCard1 extends StatelessWidget {
  const VideoCard1({
    super.key,
    required this.videoID,
    required this.videoThumbnailUrl,
    required this.videoTitle,
    required this.videoDate,
  });

  final String videoID;
  final String videoThumbnailUrl;
  final String videoTitle;
  final String videoDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("RanjeetTest============>" + videoDate);

        Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) => PlayerScreen(videoID: videoID),
              builder: (context) => PlayerScreenNew(videoID: videoID, title: videoTitle, description: videoDate, publishedAtDate: '', publishedAtTime: '',),

          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 10.0,
        ),
        child: Card(
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(videoThumbnailUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                )
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 12,
                  right: 17,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        videoTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      videoDate != ""
                          ? Text(
                        videoDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LSCard extends StatelessWidget {
  const LSCard({
    super.key,
    required this.livestreamUrl,
    required this.livestreamThumbnailUrl,
    required this.livestreamTitle,
  });

  final String livestreamUrl;
  final String livestreamThumbnailUrl;
  final String livestreamTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LivePlayerScreen(
              liveStreamTitle: livestreamTitle,
              livestreamUrl: livestreamUrl,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 10.0,
        ),
        child: Card(
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(livestreamThumbnailUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                )
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 12,
                  right: 17,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$livestreamTitle | Live",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
