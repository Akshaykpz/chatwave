class Message {
  Message({
    required this.toid,
    required this.msg,
    required this.read,
    required this.type,
    required this.send,
    required this.fromid,
  });
  late final String toid;
  late final String msg;
  late final String read;
  late final Type type;
  late final String send;
  late final String fromid;

  Message.fromJson(Map<String, dynamic> json) {
    toid = json['toid'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image ? Type.image : Type.text;
    send = json['send'].toString();
    fromid = json['fromid'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toid'] = toid;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['send'] = send;
    data['fromid'] = fromid;
    return data;
  }
}

enum Type { text, image }
