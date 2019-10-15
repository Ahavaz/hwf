class Categories {
  String name;
  int ratio;

  Categories({this.name, this.ratio});

  Categories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ratio = json['ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['ratio'] = this.ratio;
    return data;
  }
}
