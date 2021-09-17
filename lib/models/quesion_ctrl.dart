class QuestionCtrl {
  String id;
  int typeid;
  String title;
  String subtitle;
  List<Body_json> body_json;
  List<ChildJson> childJson;
  List<Answer> answer;

  QuestionCtrl(
      {this.id,
        this.typeid,
        this.title,
        this.subtitle,
        this.body_json,
        this.childJson,
        this.answer});

  QuestionCtrl.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeid = json['typeid'];
    title = json['title'];
    subtitle = json['subtitle'];
    if (json['body_json'] != null) {
      body_json = new List<Body_json>();
      json['body_json'].forEach((v) {
        body_json.add(new Body_json.fromJson(v));
      });
    }
    if (json['child_json'] != null) {
      childJson = new List<ChildJson>();
      json['child_json'].forEach((v) {
        childJson.add(new ChildJson.fromJson(v));
      });
    }
    if (json['answer'] != null) {
      answer = new List<Answer>();
      json['answer'].forEach((v) {
        answer.add(new Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['typeid'] = this.typeid;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    if (this.body_json != null) {
      data['body_json'] = this.body_json.map((v) => v.toJson()).toList();
    }
    if (this.childJson != null) {
      data['child_json'] = this.childJson.map((v) => v.toJson()).toList();
    }
    if (this.answer != null) {
      data['answer'] = this.answer.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Body_json {
  int id;
  String item;
  String descr;

  Body_json({this.id, this.item, this.descr});

  Body_json.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    item = json['item'];
    descr = json['descr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item'] = this.item;
    data['descr'] = this.descr;
    return data;
  }
}

class ChildJson {
  int id;
  String item;
  String descr;
  ChildJson({this.id, this.item, this.descr});
  ChildJson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    item = json['item'];
    descr = json['descr'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item'] = this.item;
    data['descr'] = this.descr;
    return data;
  }
}
class Answer {
  int id;
  int match;

  Answer({this.id, this.match});

  Answer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    match = json['match'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['match'] = this.match;
    return data;
  }
}

