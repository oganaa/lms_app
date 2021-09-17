class Content {
  Config config;
  List<Lessons> lessons;
  List<Categories> categories;

  Content({this.config, this.lessons, this.categories});

  fromJson(Map<String, dynamic> json) {
    config =
    json['config'] != null ? new Config.fromJson(json['config']) : null;
    if (json['lessons'] != null) {
      lessons = new List<Lessons>();
      json['lessons'].forEach((v) {
        lessons.add(new Lessons.fromJson(v));
        // print('lessons.fromjson--- ${v}');
      });
    }
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.config != null) {
      data['config'] = this.config.toJson();
    }
    if (this.lessons != null) {
      data['lessons'] = this.lessons.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Config {
  String orgName;
  String websiteTitle;
  String websiteDescr;
  String websiteVersion;

  Config(
      {this.orgName,
        this.websiteTitle,
        this.websiteDescr,
        this.websiteVersion});

  Config.fromJson(Map<String, dynamic> json) {
    orgName = json['orgName'];
    websiteTitle = json['websiteTitle'];
    websiteDescr = json['websiteDescr'];
    websiteVersion = json['websiteVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgName'] = this.orgName;
    data['websiteTitle'] = this.websiteTitle;
    data['websiteDescr'] = this.websiteDescr;
    data['websiteVersion'] = this.websiteVersion;
    return data;
  }
}

class Lessons {
  String id;
  String alias;
  int categoryId;
  String category;
  String duration;
  int viewcnt;
  String name;
  String descr;
  String descrLong;
  String imgUrl;
  String previewUrl;
  List<Results> results;
  List<Chapter> chapter;

  Lessons(
      {this.id,
        this.alias,
        this.categoryId,
        this.category,
        this.duration,
        this.viewcnt,
        this.name,
        this.descr,
        this.descrLong,
        this.imgUrl,
        this.previewUrl,
        this.results,
        this.chapter});

  Lessons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
    categoryId = json['categoryId'];
    category = json['category'];
    duration = json['duration'];
    viewcnt = json['viewcnt'];
    name = json['name'];
    descr = json['descr'];
    descrLong = json['descrLong'];
    imgUrl = json['imgUrl'];
    previewUrl = json['previewUrl'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
    if (json['chapter'] != null) {
      chapter = new List<Chapter>();
      json['chapter'].forEach((v) {
        chapter.add(new Chapter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['categoryId'] = this.categoryId;
    data['category'] = this.category;
    data['duration'] = this.duration;
    data['viewcnt'] = this.viewcnt;
    data['name'] = this.name;
    data['descr'] = this.descr;
    data['descrLong'] = this.descrLong;
    data['imgUrl'] = this.imgUrl;
    data['previewUrl'] = this.previewUrl;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    if (this.chapter != null) {
      data['chapter'] = this.chapter.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String result;
  String descr;

  Results({this.result, this.descr});

  Results.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    descr = json['descr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['descr'] = this.descr;
    return data;
  }
}

class Chapter {
  String id;
  String name;
  String duration;
  List<Topics> topics;

  Chapter({this.id, this.name, this.duration, this.topics});

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    if (json['topics'] != null) {
      topics = new List<Topics>();
      json['topics'].forEach((v) {
        topics.add(new Topics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['duration'] = this.duration;
    if (this.topics != null) {
      data['topics'] = this.topics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topics {
  String id;
  String name;
  String duration;
  String videoUrl;
  String fileUrl;

  Topics({this.id, this.name, this.duration, this.videoUrl, this.fileUrl});

  Topics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    videoUrl = json['videoUrl'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['duration'] = this.duration;
    data['videoUrl'] = this.videoUrl;
    data['fileUrl'] = this.fileUrl;
    return data;
  }
}

class Categories {
  int id;
  String name;
  List<int> lessons;
  String imgUrl;
  int lessonCnt;
  String linkUrl;
  List<Lessons> items;

  Categories(
      {this.id,
        this.name,
        this.lessons,
        this.imgUrl,
        this.lessonCnt,
        this.linkUrl});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lessons = json['lessons'].cast<int>();
    imgUrl = json['imgUrl'];
    lessonCnt = json['lessonCnt'];
    linkUrl = json['linkUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lessons'] = this.lessons;
    data['imgUrl'] = this.imgUrl;
    data['lessonCnt'] = this.lessonCnt;
    data['linkUrl'] = this.linkUrl;
    return data;
  }
}
