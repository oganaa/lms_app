class Message{
  String text;
  String name;
  String time;
  String id;
  Message({this.name, this.text, this.time, this.id });
  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
    time = json['time'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['text'] = this.text;
    data['time'] = this.time;
    data['id'] = this.id;
    return data;
  }
}