class Program {
  String? id;
  String? name;
  int? durationInDays;
  String? coverImgUrl;
  // add exercises

  Program({
    required this.id,
    required this.name,
    required this.durationInDays,
    required this.coverImgUrl
  });

  Program.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    durationInDays = json['durationInDays'];
    coverImgUrl = json['coverImgUrl'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['durationInDays'] = durationInDays;
    data['coverImgUrl'] = coverImgUrl;
    return data;
  }
}