class ActionData {
  int typeid;
  String name;
  String id;
  String pagenum;
  String time;
  Map<String, dynamic> actions;
  ActionData({this.typeid, this.name, this.id, this.pagenum, this.time});

  ActionData.fromJson(Map<String, dynamic> json) {
    typeid = json['typeid'];
    name = json['name'];
    id = json['id'];
    pagenum = json['pagenum'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeid'] = this.typeid;
    data['name'] = this.name;
    data['id'] = this.id;
    data['pagenum'] = this.pagenum;
    data['time'] = this.time;
    return data;
  }
}