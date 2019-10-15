import 'listTests.dart';

class Tests {
  int score;
  int testsPassed;
  int testsWaiting;
  int allAnswers;
  int ratioCorrect;
  int ratioIncorrect;
  List<ListTests> listTests;

  Tests(
      {this.score,
      this.testsPassed,
      this.testsWaiting,
      this.allAnswers,
      this.ratioCorrect,
      this.ratioIncorrect,
      this.listTests});

  Tests.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    testsPassed = json['testsPassed'];
    testsWaiting = json['testsWaiting'];
    allAnswers = json['allAnswers'];
    ratioCorrect = json['ratioCorrect'];
    ratioIncorrect = json['ratioIncorrect'];
    if (json['listTests'] != null) {
      listTests = new List<ListTests>();
      json['listTests'].forEach((v) {
        listTests.add(new ListTests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['testsPassed'] = this.testsPassed;
    data['testsWaiting'] = this.testsWaiting;
    data['allAnswers'] = this.allAnswers;
    data['ratioCorrect'] = this.ratioCorrect;
    data['ratioIncorrect'] = this.ratioIncorrect;
    if (this.listTests != null) {
      data['listTests'] = this.listTests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
