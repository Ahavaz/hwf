class ListTests {
  String imageurl;
  String description;
  int score;

  ListTests({this.imageurl, this.description, this.score});

  ListTests.fromJson(Map<String, dynamic> json) {
    imageurl = json['imageurl'];
    description = json['description'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageurl'] = this.imageurl;
    data['description'] = this.description;
    data['score'] = this.score;
    return data;
  }
}
