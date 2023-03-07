class Exercise {
  String? id;
  String? name;
  int? durationInMins;
  String? coverImgUrl;
  // add exercises

  Exercise({
    required this.id,
    required this.name,
    required this.durationInMins,
    required this.coverImgUrl
  });

  Exercise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    durationInMins = json['durationInMins'];
    coverImgUrl = json['coverImgUrl'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['durationInMins'] = durationInMins;
    data['coverImgUrl'] = coverImgUrl;
    return data;
  }
}