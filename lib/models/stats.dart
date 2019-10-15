import 'categories.dart';

class Stats {
  int wordsRead;
  double listenTime;
  int totalBooks;
  List<int> weekdaysBooks;
  List<Categories> categories;

  Stats({
    this.wordsRead,
    this.listenTime,
    this.totalBooks,
    this.weekdaysBooks,
    this.categories,
  });

  Stats.fromJson(Map<String, dynamic> json) {
    wordsRead = json['wordsRead'];
    listenTime = json['listenTime'];
    totalBooks = json['totalBooks'];
    weekdaysBooks = json['weekdaysBooks'].cast<int>();
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wordsRead'] = this.wordsRead;
    data['listenTime'] = this.listenTime;
    data['totalBooks'] = this.totalBooks;
    data['weekdaysBooks'] = this.weekdaysBooks;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
