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
  late final String image;
  late final String about;
  late final String name;
  late final String createAt;
  late final bool isonline;
  late final String id;
  late final String lastactive;
  late final String email;
  late final String pushtoken;
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
