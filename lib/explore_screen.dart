import 'package:flutter/material.dart';
import 'package:sansadtv_app/archive_screen.dart';
import 'package:sansadtv_app/constants.dart';
import 'package:sansadtv_app/themes.dart';
import 'package:sansadtv_app/web_content_handler.dart';
import 'package:universal_html/html.dart' as html;

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, this.doc});

  final dynamic doc;

  @override
  State<ExploreScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<ExploreScreen> {
  late List<List<NavItem>> navigationStack = [[]];
  late html.HtmlDocument document;
  late html.Element menuElement;
  int currIndex = 0;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    navigationStack = [];
    fetchDocument();
  }

  void fetchDocument() async {
    if (widget.doc == null) return;
    document = widget.doc;
    menuElement = document.getElementById('menu-main-menu') as html.Element;
    fetchNavItems(menuElement);
    cleanNavItems();
    navigationStack[0][0].children.add(navigationStack[0][4]);
    navigationStack[0].removeLast();
  }

  void cleanNavItems() {
    if (navigationStack.isNotEmpty && navigationStack.first.isNotEmpty) {
      navigationStack.first.removeWhere(
        (item) => !exploreItems.containsKey(item.label),
      );

      setState(() {});
    }
  }

  void fetchNavItems(html.Element parent) async {
    List<NavItem> navItems = [];
    for (var el in parent.children) {
      navItems.add(NavItem(el));
    }
    if (navigationStack.length <= currIndex) {
      navigationStack.add(navItems);
    } else {
      navigationStack[currIndex] = navItems;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 19.0,
                  top: 15.0,
                ),
                child: Text(
                  'Explore',
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
              Expanded(
                child: PageView.builder(
                  onPageChanged: (int pageIndex) {
                    if (pageIndex != navigationStack.length - 1) {
                      setState(() {
                        currIndex = pageIndex;
                      });
                    }
                  },
                  controller: pageController,
                  itemCount: currIndex + 1,
                  itemBuilder: (context, pageIndex) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 10.0,
                      ),
                      decoration: pageCardDecoration().copyWith(color: const Color.fromRGBO(240, 239, 245, 1)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: navigationStack.isNotEmpty
                              ? [
                                  if (pageIndex != 0)
                                    InkWell(
                                      onTap: () {
                                        pageController.animateToPage(
                                          pageIndex - 1,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Icon(
                                            Icons.chevron_left_rounded,
                                            size: 50.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: listDecoration(),
                                      child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: navigationStack[pageIndex].length,
                                        itemBuilder: (context, itemIndex) {
                                          return Container(
                                            decoration: itemIndex != 0
                                                ? const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (navigationStack[pageIndex][itemIndex].children.isNotEmpty) {
                                                  currIndex++;
                                                  if (navigationStack.length <= currIndex) {
                                                    navigationStack.add(navigationStack[pageIndex][itemIndex].children);
                                                  } else {
                                                    navigationStack[currIndex] = navigationStack[pageIndex][itemIndex].children;
                                                  }

                                                  pageController.animateToPage(
                                                    navigationStack.length - 1,
                                                    duration: const Duration(milliseconds: 300),
                                                    curve: Curves.easeInOut,
                                                  );
                                                  setState(() {});
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ArchiveScreen(query: navigationStack[pageIndex][itemIndex].label),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 18.0,
                                                  vertical: 16.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    exploreItems[navigationStack[pageIndex][itemIndex].label] ?? Container(),
                                                    const SizedBox(
                                                      width: 13.0,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        navigationStack[pageIndex][itemIndex].label != 'More' ? navigationStack[pageIndex][itemIndex].label : 'Special Corner',
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: navigationStack[pageIndex][itemIndex].children.isNotEmpty ? const Icon(Icons.arrow_forward_ios_rounded) : null,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  pageIndex == 0
                                      ? const SizedBox(
                                          height: 10.0,
                                        )
                                      : Container(),
                                  pageIndex == 0
                                      ? Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            decoration: listDecoration(),
                                            child: ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: staticPages.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  decoration: index != 0
                                                      ? const BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        )
                                                      : null,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => staticPages[index][1],
                                                        ),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 14.0,
                                                        vertical: 16,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          staticPages[index][2] ?? Container(),
                                                          const SizedBox(
                                                            width: 13.0,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              staticPages[index][0],
                                                              style: const TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ]
                              : [],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
