
class Recentshowmodel {
  Recentshowmodel({
    required this.recentShows,
  });
  late final List<RecentShows> recentShows;

  Recentshowmodel.fromJson(Map<dynamic, dynamic> json){
    recentShows = List.from(json['recent_shows']).map((e)=>RecentShows.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['recent_shows'] = recentShows.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class RecentShows {
  RecentShows({
    required this.ID,
    required this.title,
    required this.shortDisc,
    required this.fullDesc,
    required this.Img,
    required this.episode_iframe_video,
    this.show_iframe_video,
  });
  late final int ID;
  late final String title;
  late final String shortDisc;
  late final String fullDesc;
  late final String Img;
  late final String episode_iframe_video;
  late final Null show_iframe_video;

  RecentShows.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
    title = json['title'];
    shortDisc = json['shortDisc'];
    fullDesc = json['fullDesc'];
    Img = json['Img'];
    episode_iframe_video = json['episode-iframe-video'];
    show_iframe_video = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['title'] = title;
    _data['shortDisc'] = shortDisc;
    _data['fullDesc'] = fullDesc;
    _data['Img'] = Img;
    _data['episode-iframe-video'] = episode_iframe_video;
    _data['show-iframe-video'] = show_iframe_video;
    return _data;
  }
}