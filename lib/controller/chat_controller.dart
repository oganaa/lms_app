class ChatController {
  List<UserId> userId;
  String sId;
  RoomId roomId;
  int iV;
  String id;

  ChatController({this.userId, this.sId, this.roomId, this.iV, this.id});

  ChatController.fromJson(Map<String, dynamic> json) {
    if (json['userId'] != null) {
      userId = new List<UserId>();
      json['userId'].forEach((v) {
        userId.add(new UserId.fromJson(v));
      });
    }
    sId = json['_id'];
    roomId =
    json['roomId'] != null ? new RoomId.fromJson(json['roomId']) : null;
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userId != null) {
      data['userId'] = this.userId.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    if (this.roomId != null) {
      data['roomId'] = this.roomId.toJson();
    }
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}

class UserId {
  String sId;
  String name;
  String avatar;

  UserId({this.sId, this.name, this.avatar});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}

class RoomId {
  String roomType;
  String sId;
  String name;
  int iV;
  List<Messages> messages;
  String id;

  RoomId({this.roomType, this.sId, this.name, this.iV, this.messages, this.id});

  RoomId.fromJson(Map<String, dynamic> json) {
    roomType = json['roomType'];
    sId = json['_id'];
    name = json['name'];
    iV = json['__v'];
    if (json['messages'] != null) {
      messages = new List<Messages>();
      json['messages'].forEach((v) {
        messages.add(new Messages.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomType'] = this.roomType;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class Messages {
  String sId;
  String senderId;
  String roomId;
  String content;
  String time;
  int iV;

  Messages(
      {this.sId, this.senderId, this.roomId, this.content, this.time, this.iV});

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['senderId'];
    roomId = json['roomId'];
    content = json['content'];
    time = json['time'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['senderId'] = this.senderId;
    data['roomId'] = this.roomId;
    data['content'] = this.content;
    data['time'] = this.time;
    data['__v'] = this.iV;
    return data;
  }
}
