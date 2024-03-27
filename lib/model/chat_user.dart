class ChatUser {
  ChatUser(
      {required this.image,
      required this.about,
      required this.name,
      required this.createAt,
      required this.isonline,
      required this.id,
      required this.lastactive,
      required this.email,
      required this.pushtoken});
  late String image;
  late String about;
  late String name;
  late String createAt;
  late bool isonline;
  late String id;
  late String lastactive;
  late String email;
  late String pushtoken;
  ChatUser.fromjson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    about = json['about'] ?? '';
    name = json['name'] ?? "";
    createAt = json['createAt'] ?? "";
    isonline = json['isonline'] ?? "";
    id = json['id'] ?? "";
    lastactive = json['lastactive'] ?? "";
    email = json['email'] ?? "";
    pushtoken = json['pushtoken'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['createdAt'] = createAt;
    data['isonline'] = isonline;
    data['id'] = id;
    data['lastActive'] = lastactive;
    data['email'] = email;
    data['pushtoken'] = pushtoken;
    return data;
  }
}
