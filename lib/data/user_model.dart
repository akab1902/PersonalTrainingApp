class User {
  String? username;
  String? photoUrl;
  String? email;

  User({
    required this.username,
    required this.email,
    required this.photoUrl
  });

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    photoUrl = json['photoUrl'];
    email = json['email'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = username;
    data['photoUrl'] = photoUrl;
    data['email'] = email;
    return data;
  }
}