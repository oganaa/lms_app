class DrawState {
  int typeid;
  String name;
  String id;
  int pagenum;
  String time;
  Drawjson drawjson;

  DrawState(
      {this.typeid,
        this.name,
        this.id,
        this.pagenum,
        this.time,
        this.drawjson});

  DrawState.fromJson(Map<String, dynamic> json) {
    typeid = json['typeid'];
    name = json['name'];
    id = json['id'];
    pagenum = json['pagenum'];
    time = json['time'];
    drawjson = json['drawjson'] != null
        ? new Drawjson.fromJson(json['drawjson'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeid'] = this.typeid;
    data['name'] = this.name;
    data['id'] = this.id;
    data['pagenum'] = this.pagenum;
    data['time'] = this.time;
    if (this.drawjson != null) {
      data['drawjson'] = this.drawjson.toJson();
    }
    return data;
  }
}

class Drawjson {
  DrawAction drawAction;

  Drawjson({this.drawAction});

  Drawjson.fromJson(Map<String, dynamic> json) {
    drawAction = json['drawAction'] != null
        ? new DrawAction.fromJson(json['drawAction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.drawAction != null) {
      data['drawAction'] = this.drawAction.toJson();
    }
    return data;
  }
}

class DrawAction {
  int typeid;
  String eventName;
  String userId;
  String userName;
  int width;
  int height;
  Jsonobj jsonobj;

  DrawAction(
      {this.typeid, this.eventName, this.userId, this.userName,this.width,this.height, this.jsonobj});

  DrawAction.fromJson(Map<String, dynamic> json) {
    typeid = json['typeid'];
    eventName = json['eventName'];
    userId = json['userId'];
    userName = json['userName'];
    // width = json['width'];
    // height = json['height'];
    jsonobj =
    json['jsonobj'] != null ? new Jsonobj.fromJson(json['jsonobj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeid'] = this.typeid;
    data['eventName'] = this.eventName;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    if (this.jsonobj != null) {
      data['jsonobj'] = this.jsonobj.toJson();
    }
    return data;
  }
}

class Jsonobj {
  String sendColor;
  int sendWidth;
  List<Offsets> offsets;

  Jsonobj({this.sendColor, this.sendWidth, this.offsets});

  Jsonobj.fromJson(Map<String, dynamic> json) {
    sendColor = json['sendColor'];
    sendWidth = json['sendWidth'];
    if (json['offsets'] != null) {
      offsets = new List<Offsets>();
      json['offsets'].forEach((v) {
        offsets.add(new Offsets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sendColor'] = this.sendColor;
    data['sendWidth'] = this.sendWidth;
    if (this.offsets != null) {
      data['offsets'] = this.offsets.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Offsets {
  int x;
  int y;

  Offsets({this.x, this.y});

  Offsets.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}