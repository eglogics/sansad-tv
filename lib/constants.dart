import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sansadtv_app/static_data_pages.dart';

const String channelId = "UCISgnSNwqQ2i8lhCun3KtQg";

const String androidApiKey = "AIzaSyDzGn4DKuZil1Z2gNypaVyeOj8oi0VxqUw";
const String iOSApiKey = "AIzaSyB1tFBrvY_Z2-gVC9WBtmhgHnmpl2kSGjk";

String getApiKey() {
  if (Platform.isIOS) {
    return iOSApiKey;
  } else {
    return androidApiKey;
  }
}

const int recentVideosLimit = 50;
const int livestreamLimit = 20;
const int searchVideosLimit = 50;

const String webUrl = "https://sansadtv.nic.in";
const String fbUrl = "http://www.facebook.com/SansadTelevision";
const String instaUrl = "http://www.instagram.com/sansad.tv/";
const String kooUrl = "https://www.kooapp.com/profile/Sansad_TV";
const String xUrl = "http://twitter.com/sansad_tv";
const String ytUrl = "https://www.youtube.com/c/sansadtv";
const String noticeUrl = "https://sansadtv.nic.in/notices";

const String lsLiveUrl = "https://hls.media.nic.in/hls/live/lstv/lstv.m3u8";
const String rsLiveUrl = "https://hls.media.nic.in/hls/live/rstv/rstv.m3u8";
const String certificate = '''-----BEGIN CERTIFICATE-----
MIIGLjCCBRagAwIBAgIQCLJ48FI6XOq6u63YgGQaUTANBgkqhkiG9w0BAQsFADBg
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMR8wHQYDVQQDExZSYXBpZFNTTCBUTFMgUlNBIENBIEcx
MB4XDTIzMDgyMjAwMDAwMFoXDTI0MDkyMTIzNTk1OVowGjEYMBYGA1UEAxMPc2Fu
c2FkdHYubmljLmluMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz56V
GCfBM/8NFdV4wbpwWiKqInGE2t2cElOgkU4Vueihd0pUoXFgeFWxCRHryyPVQFgz
78YrTJWCpw7gFRJvtfzPu5rFIBPcKEq7hZhtxwtIkZAWzcbYBoe3Yv4nVV6Ifa7R
raKXrRLq4kVgO/q4VA/AnP+RAQ5Nz2nWyTbxzBuTZt5xfs1Yo9ULQgEY/216FW/v
0/CoyTy1TC0EUsNTbP7MHDmZDvrUUvqZHG9dYBJZeimfZjkpRUs889CnkSwCmEzn
Uav6H07ulvZgW7miABPECKbBtzTb6ybg1GCLZKpW/an5vyT3cvqvOMiwgrQiVtAo
BB8iKEtcomH4b36cAwIDAQABo4IDKDCCAyQwHwYDVR0jBBgwFoAUDNtsgkkPSmcK
uBTuesRIUojrVjgwHQYDVR0OBBYEFGxWRg9x3nCFx6Vse2wIElw0uaayMC8GA1Ud
EQQoMCaCD3NhbnNhZHR2Lm5pYy5pboITd3d3LnNhbnNhZHR2Lm5pYy5pbjAOBgNV
HQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMD8GA1Ud
HwQ4MDYwNKAyoDCGLmh0dHA6Ly9jZHAucmFwaWRzc2wuY29tL1JhcGlkU1NMVExT
UlNBQ0FHMS5jcmwwPgYDVR0gBDcwNTAzBgZngQwBAgEwKTAnBggrBgEFBQcCARYb
aHR0cDovL3d3dy5kaWdpY2VydC5jb20vQ1BTMHYGCCsGAQUFBwEBBGowaDAmBggr
BgEFBQcwAYYaaHR0cDovL3N0YXR1cy5yYXBpZHNzbC5jb20wPgYIKwYBBQUHMAKG
Mmh0dHA6Ly9jYWNlcnRzLnJhcGlkc3NsLmNvbS9SYXBpZFNTTFRMU1JTQUNBRzEu
Y3J0MAkGA1UdEwQCMAAwggF8BgorBgEEAdZ5AgQCBIIBbASCAWgBZgB1AHb/iD8K
tvuVUcJhzPWHujS0pM27KdxoQgqf5mdMWjp0AAABihwyjfkAAAQDAEYwRAIgIN0G
Gc8syT7SRhp0+a6oXr+fXKRXzwewVo+3CgebV14CIGJ7nAba45V42XvUnvwdoeAc
KJfLfwCdRzxnV3ah6427AHUASLDja9qmRzQP5WoC+p0w6xxSActW3SyB2bu/qznY
hHMAAAGKHDKNVwAABAMARjBEAiATkdURoiHXDaFqUWxjlLuRGOW4Yn612T6oh1qd
uLD8dAIgewcvBtCRD7VQ7l6L+ijZ/i6ZUVY+4D+pvo5NSUhqaNAAdgDatr9rP7W2
Ip+bwrtca+hwkXFsu1GEhTS9pD0wSNf7qwAAAYocMo0JAAAEAwBHMEUCIACPb5za
/GD6OtQanWhW3jsd1uTkYe4aE1CfS7CuyspsAiEAhWtz7qevGlUKNPv6Zj1ipHQI
R2dC2+1rUEgvjZKaT5kwDQYJKoZIhvcNAQELBQADggEBAKBRLZLpx6540MMKSOH3
AyBhUfs6EoUje/ppW6AASmF5yQlwZJ3u7uUSfvcIma4KlFTFPMsbE949xtcEvcX5
rszXsedGSZiQftuh4bP7re9cnXMrU/oHEmtklCtP7yViU9WtEXEppVFHhvFd9fnv
iQtpCdFB1IEKKSfnxxVKDVkXI5C4pvqCGBT8Lpgup5gwxo6Ms+LlEC+40mxhhPok
Y6SQz2H8h6cCNCo3Vamk8Y91y3ubSpb/sxnD0KULkRpJv6I6ef2RpgjntAEjUhxd
oqXXiJvdtnzcP9HLY20lq01Eus3W/Qo0KrfC/QUqM8GH3AGlL6Q9hRrpcwWj/cJN
FmY=
-----END CERTIFICATE-----''';

const Map<String, Widget> exploreItems = {
  "Shows": Icon(Icons.tv_rounded),
  "Archive": Icon(Icons.archive_outlined),
  "Parliament": Icon(Icons.living_outlined),
  "More": Icon(Icons.star_rounded),
  "Swasth Bharat Samarth Bharat": SizedBox(),
};

const List<List<dynamic>> staticPages = [
  [
    "About us",
    AboutScreen(),
    Icon(Icons.info_outline),
  ],
  [
    "Governing Council",
    CouncilScreen(),
    Icon(Icons.account_balance),
  ],
  [
    "Team Sansad TV",
    TeamScreen(),
    Icon(Icons.groups_2),
  ],
  [
    "Contact us",
    ContactScreen(),
    Icon(Icons.mail_outline),
  ]
];

const String aboutText = '''
Sansad Television is the Parliamentary channel of India. It was created in 2021 by merging Lok Sabha Television and Rajya Sabha Television.

Apart from telecasting the live proceedings of the Lower House and the Upper House of Indian Parliament, Sansad Television is committed to objectively presenting the various facets of a vibrant democracy.

As a public broadcaster, the channel aims to bring people closer to their elected representatives by making the work of parliamentary and legislative bodies of India accessible to all. It is a platform that provides not only an insightful perspective on national and international affairs but also promotes scientific temper among people while shining a light on all aspects of their political, economic, social and cultural life.

Sansad Television is dedicated to empowering the people of India — by promoting greater accountability and transparency in governance.
''';

const List<List<String>> teamDetails = [
  [
    "Shri Rajit Punhani",
    "Chief Executive Officer, Sansad TV",
    "011-23034204, 23012592",
    "r.punhani@sansad.nic.in",
  ],
  [
    "Dr. Vandana Kumar",
    "Additional CEO, Sansad TV",
    "011-23011992",
    "vandanak.cgda@nic.in",
  ],
  [
    "Shri Sumant Narain",
    "JS&FA",
    "011-23034202, 23011245",
    "narain.sumant@sansad.nic.in",
  ],
  [
    "Shri Ajaya Kumar Mallick",
    "Director, Sansad TV",
    "011-23445707",
    "ajay.mallick@sansad.nic.in",
  ],
];

const List<List<String>> councilDetails = [
  [
    "Shri Jagdeep Dhankhar",
    "Hon'ble Chairman, Rajya Sabha",
    "Chairman",
    "011-23016422, 23016344",
    "vpindia@nic.in",
  ],
  [
    "Shri Om Birla",
    "Hon'ble Speaker, Lok Sabha",
    "Co-Chairman",
    "011-23014011, 23014022",
    "speakerloksabha@sansad.nic.in",
  ],
  [
    "Shri P.C. Mody",
    "Secretary General, Rajya Sabha",
    "Member",
    "011-23083035, 23083036, 23083037",
    "secygen.rs@sansad.nic.in",
  ],
  [
    "Shri Utpal Kumar Singh",
    "Secretary General, Lok Sabha",
    "Member",
    "011-23017465, 23034255",
    "sg-loksabha@sansad.nic.in",
  ],
  [
    "Shri. Rajit Punhani",
    "CEO, Sansad TV",
    "Member-Secretary",
    "011-23083045, 23083046, 23083047",
    "r.punhani@sansad.nic.in",
  ],
];

const Map<String, String> searchKeywords = {
  "Presidential Address": "President's address",
  "Other Parliamentary Activities": "Parliament",
};
