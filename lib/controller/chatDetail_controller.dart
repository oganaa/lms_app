class ChatDetailController {
  String sId;
  String senderId;
  RoomId roomId;
  String content;
  String time;
  int iV;

  ChatDetailController(
      {this.sId, this.senderId, this.roomId, this.content, this.time, this.iV});

  ChatDetailController.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['senderId'];
    roomId =
    json['roomId'] != null ? new RoomId.fromJson(json['roomId']) : null;
    content = json['content'];
    time = json['time'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['senderId'] = this.senderId;
    if (this.roomId != null) {
      data['roomId'] = this.roomId.toJson();
    }
    data['content'] = this.content;
    data['time'] = this.time;
    data['__v'] = this.iV;
    return data;
  }
}

class RoomId {
  String roomType;
  String sId;
  String name;
  int iV;
  String id;

  RoomId({this.roomType, this.sId, this.name, this.iV, this.id});

  RoomId.fromJson(Map<String, dynamic> json) {
    roomType = json['roomType'];
    sId = json['_id'];
    name = json['name'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomType'] = this.roomType;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
