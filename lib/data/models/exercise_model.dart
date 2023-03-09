class Exercise {
  String? id;
  String? name;
  int? durationInMins;
  String? coverImgUrl;
  String? videoUrl;
  String? description;
  List<String>? steps;
  // add exercises

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.durationInMins,
    required this.coverImgUrl,
    required this.videoUrl,
    required this.steps
  });

  Exercise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    durationInMins = json['durationInMins'];
    coverImgUrl = json['coverImgUrl'];
    videoUrl = json['videoUrl'];
    steps = json['steps'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['durationInMins'] = durationInMins;
    data['coverImgUrl'] = coverImgUrl;
    data['videoUrl'] = videoUrl;
    data['steps'] = steps;
    return data;
  }
}