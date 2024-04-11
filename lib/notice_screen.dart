import 'package:flutter/material.dart';
import 'package:sansadtv_app/constants.dart';
import 'package:sansadtv_app/themes.dart';
import 'package:sansadtv_app/web_content_handler.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  late List<List<String>> notices = [];
  bool fetchStatus = true;
  @override
  void initState() {
    super.initState();
    fetchNotices();
  }

  void fetchNotices() async {
    final html.HtmlDocument document = await fetchHTML(noticeUrl);
    extractData(document);
  }

  void extractData(html.HtmlDocument doc) {
    var rows = doc.querySelectorAll("tr");
    rows.skip(1).forEach((element) {
      List<String> data = [];
      data.add(element.querySelector("p")?.innerText as String);
      data.add(element.querySelector("a")?.getAttribute("href") as String);
      data.add(element.querySelector("td")?.nextElementSibling?.innerText as String);
      notices.add(data);
    });
    setState(() {});
    // print("notices" + notices.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 19.0, top: 15.0),
                child: Text(
                  'Notice Board',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 40,
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
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                decoration: pageCardDecoration().copyWith(color: const Color.fromRGBO(240, 239, 245, 1)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 13,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return NoticeObject(headline: notices[index][0], date: notices[index][2], url: notices[index][1]);
                    },
                    itemCount: notices.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoticeObject extends StatelessWidget {
  const NoticeObject({
    super.key,
    required this.headline,
    required this.date,
    required this.url,
  });

  final String headline;
  final String date;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _launchUrl(url),
              child: Container(
                decoration: listDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.book,
                        size: 30.0,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              headline,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              date,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
