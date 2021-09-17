class User {
  String id;
  String name;
  String email;
  String room;
  bool teacher;
  User({this.id, this.name, this.email, this.room,this.teacher});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    room = json['room'];
    teacher = json['teacher'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['room'] = this.room;
    data['teacher'] = this.teacher;
    return data;
  }
}