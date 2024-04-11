import 'package:flutter/material.dart';
import 'package:sansadtv_app/constants.dart';
import 'package:sansadtv_app/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                "About us",
                style: TextStyle(
                  fontSize: 35,
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
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: pageCardDecoration(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Image.asset('images/logo-sansad.png'),
                    ),
                    const SizedBox(height: 15.0),
                    const Text(
                      aboutText,
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            height: 2,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Launched: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: 'September 15, 2021\n'),
                            TextSpan(text: 'Country: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'India\n'),
                            TextSpan(text: 'Launguage: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Hindi and English\n'),
                            TextSpan(text: 'Location: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Parliament Library Building, Parliament House, New Delhi\n'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                "Team Sansad TV",
                style: TextStyle(
                  fontSize: 35,
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
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: pageCardDecoration().copyWith(
                color: const Color.fromRGBO(240, 239, 245, 1),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: teamDetails.length,
                itemBuilder: ((context, index) {
                  return TeamCard(name: teamDetails[index][0], designation: teamDetails[index][1], number: teamDetails[index][2], email: teamDetails[index][3]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CouncilScreen extends StatelessWidget {
  const CouncilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                "Governing Council",
                style: TextStyle(
                  fontSize: 35,
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
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: pageCardDecoration().copyWith(
                color: const Color.fromRGBO(240, 239, 245, 1),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: councilDetails.length,
                itemBuilder: ((context, index) {
                  return CouncilCard(
                      name: councilDetails[index][0],
                      designation1: councilDetails[index][1],
                      designation2: councilDetails[index][2],
                      number: councilDetails[index][3],
                      email: councilDetails[index][4]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.name,
    required this.designation,
    required this.number,
    required this.email,
  });

  final String name, designation, number, email;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6.0,
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 3),
                Center(
                  child: Text(
                    designation,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40.0),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    Expanded(
                      child: Center(
                        child: Text(
                          number,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.mail),
                    Expanded(
                      child: Center(
                        child: Text(
                          email,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CouncilCard extends StatelessWidget {
  const CouncilCard({
    super.key,
    required this.name,
    required this.designation1,
    required this.designation2,
    required this.number,
    required this.email,
  });

  final String name, designation1, designation2, number, email;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6.0,
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 3),
                Center(
                  child: Text(
                    designation1,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 3),
                Center(
                  child: Text(
                    designation2,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40.0),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    Expanded(
                      child: Center(
                        child: Text(
                          number,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.mail),
                    Expanded(
                      child: Center(
                        child: Text(
                          email,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              "Contact us",
              style: TextStyle(
                fontSize: 35,
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
          const SizedBox(height: 10), // Added spacing for better readability
          Expanded(
            child: Container(
              decoration: pageCardDecoration().copyWith(
                color: const Color.fromRGBO(240, 239, 245, 1),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 18.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: listDecoration(),
                      child: const Column(
                        children: [
                          ContactItem(
                            icon: Icon(
                              Icons.location_on,
                              size: 40.0,
                            ),
                            text: "FB-116, Parliament Library Building, Parliament House Complex, New Delhi, 110001",
                          ),
                          ContactItem(
                            icon: Icon(
                              Icons.location_on,
                              size: 40.0,
                            ),
                            text: "Sansad Television, 21 & 23 Mahadev Road, New Delhi 110001",
                          ),
                          ContactItem(
                            icon: Icon(
                              Icons.email_sharp,
                              size: 40.0,
                            ),
                            text: "Email 1: sansadtv-digital[at]sansad[dot]nic[dot]in",
                          ),
                          ContactItem(
                            icon: Icon(
                              Icons.email_sharp,
                              size: 40.0,
                            ),
                            text: "Email 2: sansadtv-sm[at]sansad[dot]nic[dot]in",
                          ),
                          ContactItem(
                            icon: Icon(
                              Icons.phone,
                              size: 40.0,
                            ),
                            text: "Phone: 011-23445700",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  const ContactItem({
    super.key,
    required this.icon,
    required this.text,
  });

  final Icon icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialMediaLogo extends StatelessWidget {
  final String imageAsset;
  final String url;

  const SocialMediaLogo({
    super.key,
    required this.imageAsset,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchUrl(url);
      },
      child: Image.asset(
        imageAsset,
        width: 50.0, // Adjust the size as needed
        height: 50.0,
      ),
    );
  }

  void _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
