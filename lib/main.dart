import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'models/stats.dart';
import 'models/tests.dart';

import 'custom_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Essens test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
              decorationColor: Colors.white,
            ),
        primarySwatch: Colors.yellow,
        accentColor: Colors.yellowAccent,
        scaffoldBackgroundColor: Colors.grey[900],
        textSelectionColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
              decorationColor: Colors.white,
            ),
      ),
      home: MyHomePage(title: 'Good morning!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin<MyHomePage> {
  Stats stats;
  Tests tests;
  var statsChart;
  var testsChart;
  var initialStats = {
    "wordsRead": 0,
    "listenTime": 0.0,
    "totalBooks": 0,
    "weekdaysBooks": [0, 0, 0, 0, 0, 0, 0],
    "categories": [
      {"name": "", "ratio": 0},
      {"name": "", "ratio": 0},
      {"name": "", "ratio": 0},
      {"name": "", "ratio": 0},
      {"name": "", "ratio": 0},
      {"name": "", "ratio": 0},
    ]
  };
  var initialTests = {
    "score": 0,
    "testsPassed": 0,
    "testsWaiting": 0,
    "allAnswers": 0,
    "ratioCorrect": 0,
    "ratioIncorrect": 0,
    "listTests": [
      {"imageurl": "", "description": "", "score": 0},
      {"imageurl": "", "description": "", "score": 0},
      {"imageurl": "", "description": "", "score": 0},
      {"imageurl": "", "description": "", "score": 0},
      {"imageurl": "", "description": "", "score": 0},
      {"imageurl": "", "description": "", "score": 0},
      {"imageurl": "", "description": "", "score": 0}
    ]
  };

  _loadData() async {
    String jsonStats = await rootBundle.loadString('assets/stats.json');
    String jsonTests = await rootBundle.loadString('assets/tests.json');

    if (mounted) {
      setState(() {
        stats = Stats.fromJson(jsonDecode(jsonStats));
        tests = Tests.fromJson(jsonDecode(jsonTests));
        statsChart = <CircularStackEntry>[
          CircularStackEntry(
            <CircularSegmentEntry>[
              CircularSegmentEntry(
                double.parse('${stats.categories[0].ratio}'),
                Colors.yellow,
                rankKey: 'Q1',
              ),
              CircularSegmentEntry(
                double.parse('${stats.categories[1].ratio}'),
                Colors.orange,
                rankKey: 'Q2',
              ),
              CircularSegmentEntry(
                double.parse('${stats.categories[2].ratio}'),
                Colors.red,
                rankKey: 'Q3',
              ),
              CircularSegmentEntry(
                double.parse('${stats.categories[3].ratio}'),
                Colors.purple,
                rankKey: 'Q4',
              ),
              CircularSegmentEntry(
                double.parse('${stats.categories[4].ratio}'),
                Colors.blue,
                rankKey: 'Q5',
              ),
              CircularSegmentEntry(
                double.parse('${stats.categories[5].ratio}'),
                Colors.lightBlue[50],
                rankKey: 'Q6',
              ),
            ],
            rankKey: 'Books Finished',
          ),
        ];
        testsChart = <CircularStackEntry>[
          CircularStackEntry(
            <CircularSegmentEntry>[
              CircularSegmentEntry(
                double.parse('${tests.ratioCorrect}'),
                Colors.yellow,
                rankKey: 'Q1',
              ),
              CircularSegmentEntry(
                double.parse('${tests.ratioIncorrect}'),
                Colors.red,
                rankKey: 'Q2',
              ),
            ],
            rankKey: 'Tests Score',
          ),
        ];
      });
    }
  }

  final GlobalKey<AnimatedCircularChartState> _statsChartKey =
      new GlobalKey<AnimatedCircularChartState>();

  final GlobalKey<AnimatedCircularChartState> _testsChartKey =
      new GlobalKey<AnimatedCircularChartState>();

  List<CircularStackEntry> _initialChartData = <CircularStackEntry>[
    CircularStackEntry(
      <CircularSegmentEntry>[
        CircularSegmentEntry(
          100.0,
          Colors.black26,
        ),
      ],
    ),
  ];

  bool _hasData = true;
  int _cTab = 0;
  int _cIndex = 2;
  List<String> _weekdaysNames = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  @override
  void initState() {
    if (_hasData) {
      _loadData();
      _cycleSamples();
    }
    super.initState();
  }

  void _toggleState(bool stateData) {
    if (stateData) {
      _loadData();
      _cycleSamples();
      setState(() {
        _hasData = !stateData;
      });
    } else {
      setState(() {
        stats = Stats.fromJson(initialStats);
        tests = Tests.fromJson(initialTests);
        if (_cTab == 0)
          _statsChartKey.currentState.updateData(_initialChartData);
        if (_cTab == 1)
          _testsChartKey.currentState.updateData(_initialChartData);
        _hasData = !stateData;
      });
    }
  }

  void _navigateTo(index) {
    print('Navigating to screen');
  }

  void _cycleSamples() async {
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));

    setState(() {
      if (_cTab == 0) _statsChartKey.currentState.updateData(statsChart);

      if (_cTab == 1) _testsChartKey.currentState.updateData(testsChart);
    });
  }

  String _formatNumber(int value) {
    if (value.toString().length > 12)
      return '${(value / 1000000000000).floor()}T';

    if (value.toString().length > 9) return '${(value / 1000000000).floor()}B';

    if (value.toString().length > 6) return '${(value / 1000000).floor()}M';

    if (value.toString().length > 3) return '${(value / 1000).floor()}k';

    return '$value';
  }

  String _formatTime(double value) {
    if (value == 0) return '${0}h';

    if (value >= 24) return '${(value / 24).floor()}d';

    if (value < 1) return '${(value * 60).floor()}min';

    return '${value}h';
  }

  @override
  Widget build(BuildContext context) {
    if (stats == null ||
        stats.categories == null ||
        tests == null ||
        tests.listTests == null) return Container();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 15,
          title: Text(
            widget.title,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black26,
          brightness: Brightness.dark,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () {
                print('Settings clicked');
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(160.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Text(
                      '1 Random Book / per day',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: RaisedButton(
                        child: Text(
                          'Upgrade to pro',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        color: Colors.yellowAccent,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: () {
                          print('Upgrade clicked');
                        }),
                  ),
                  TabBar(
                    onTap: (index) {
                      if (!_hasData) {
                        setState(() {
                          _cTab = index;
                        });
                        _cycleSamples();
                      }
                    },
                    tabs: <Widget>[
                      Tab(text: 'My Stats'),
                      Tab(text: 'My Tests'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: TabBarView(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 40.0, bottom: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'This week activity: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                stats != null && stats.totalBooks == 0
                                    ? 'Let\'s start!'
                                    : 'Keep going!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.yellowAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 40),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1.0,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _weekdaysNames
                                .asMap()
                                .map(
                                  (i, weekday) => MapEntry(
                                    i,
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: stats != null &&
                                                    stats.weekdaysBooks[i] == 0
                                                ? Colors.grey[800]
                                                : Colors.yellowAccent,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(1.5),
                                          child: CircleAvatar(
                                            radius: 18.0,
                                            child: Text(
                                              '${stats.weekdaysBooks[i]}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            foregroundColor:
                                                stats.weekdaysBooks[i] == 0
                                                    ? Colors.white
                                                    : Colors.black,
                                            backgroundColor:
                                                stats.weekdaysBooks[i] == 0
                                                    ? Colors.grey[900]
                                                    : Colors.yellowAccent,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            weekday.toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: stats.weekdaysBooks[i] == 0
                                                  ? Colors.grey
                                                  : Colors.yellowAccent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .values
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            'General stats',
                            style: Theme.of(context).textTheme.display1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    _formatNumber(stats.wordsRead),
                                    style: Theme.of(context).textTheme.display1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'words read',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              child: Text(
                                '',
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    _formatTime(stats.listenTime),
                                    style: Theme.of(context).textTheme.display1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'listen time',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              child: Text(
                                '',
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '${stats.totalBooks}',
                                    style: Theme.of(context).textTheme.display1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'books',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        AnimatedCircularChart(
                          key: _statsChartKey,
                          size: const Size(300.0, 300.0),
                          initialChartData: _initialChartData,
                          chartType: CircularChartType.Radial,
                          holeLabel: '${stats.totalBooks}',
                          labelStyle: Theme.of(context).textTheme.display1,
                          holeRadius: 75.0,
                          duration: Duration(milliseconds: 500),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 10.0, right: 10.0, bottom: 40.0),
                          child: stats.totalBooks == 0
                              ? Text(
                                  'O processo complicado de decorar uma página da Web com fontes personalizadas exigia a conversão e incorporação de arquivos',
                                  style: TextStyle(
                                    height: 1.8,
                                    fontSize: 15,
                                    color: Colors.grey[400],
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.only(
                                                          right: 10, left: 40),
                                                      color: Colors.yellow,
                                                    ),
                                                    Text(
                                                        '${stats.categories[0].ratio}% ${stats.categories[0].name}'),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.only(
                                                          right: 10, left: 40),
                                                      color: Colors.orange,
                                                    ),
                                                    Text(
                                                        '${stats.categories[1].ratio}% ${stats.categories[1].name}'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.only(
                                                          right: 10, left: 40),
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                        '${stats.categories[2].ratio}% ${stats.categories[2].name}'),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.only(
                                                          right: 10, left: 40),
                                                      color: Colors.purple,
                                                    ),
                                                    Text(
                                                        '${stats.categories[3].ratio}% ${stats.categories[3].name}'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.only(
                                                          right: 10, left: 40),
                                                      color: Colors.blue,
                                                    ),
                                                    Text(
                                                        '${stats.categories[4].ratio}% ${stats.categories[4].name}'),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.only(
                                                          right: 10, left: 40),
                                                      color:
                                                          Colors.lightBlue[50],
                                                    ),
                                                    Text(
                                                        '${stats.categories[5].ratio}% ${stats.categories[5].name}'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: RaisedButton.icon(
                                          label: Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0,
                                                right: 50.0,
                                                bottom: 20.0),
                                            child: Text(
                                              'Share Your Stats',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          icon: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 50.0),
                                              child: Icon(Icons.share)),
                                          color: Colors.yellowAccent,
                                          elevation: 4.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                          ),
                                          onPressed: () {
                                            print('Share stats clicked');
                                          }),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            'Test Results',
                            style: Theme.of(context).textTheme.display1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '${tests.score}',
                                    style: Theme.of(context).textTheme.display1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'score',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              child: Text(
                                '',
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '${tests.testsPassed}',
                                    style: Theme.of(context).textTheme.display1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'tests passed',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              child: Text(
                                '',
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '${tests.testsWaiting}',
                                    style: Theme.of(context).textTheme.display1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'tests waiting',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        AnimatedCircularChart(
                          key: _testsChartKey,
                          size: const Size(300.0, 300.0),
                          initialChartData: _initialChartData,
                          chartType: CircularChartType.Radial,
                          holeLabel: '${tests.allAnswers}',
                          labelStyle: Theme.of(context).textTheme.display1,
                          holeRadius: 75.0,
                          duration: Duration(milliseconds: 500),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 10.0, right: 10.0, bottom: 40.0),
                          child: tests.allAnswers == 0
                              ? Text(
                                  'O processo complicado de decorar uma página da Web com fontes personalizadas exigia a conversão e incorporação de arquivos',
                                  style: TextStyle(
                                    height: 1.8,
                                    fontSize: 15,
                                    color: Colors.grey[400],
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.only(
                                                          right: 10, left: 40),
                                                      color: Colors.yellow,
                                                    ),
                                                    Text(
                                                        '${tests.ratioCorrect}% correct'),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.only(
                                                          right: 10, left: 40),
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                        '${tests.ratioIncorrect}% incorrect'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: RaisedButton.icon(
                                          label: Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0,
                                                right: 50.0,
                                                bottom: 20.0),
                                            child: Text(
                                              'Share Your Results',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          icon: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 50.0),
                                              child: Icon(Icons.share)),
                                          color: Colors.yellowAccent,
                                          elevation: 4.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                          ),
                                          onPressed: () {
                                            print('Share results clicked');
                                          }),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _cIndex,
          backgroundColor: Colors.black26,
          selectedItemColor: Colors.yellowAccent,
          iconSize: 36,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: SizedBox.shrink()),
            BottomNavigationBarItem(
                icon: Icon(CustomIcons.menu_book), title: SizedBox.shrink()),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), title: SizedBox.shrink()),
          ],
          onTap: (index) {
            _navigateTo(index);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _toggleState(_hasData);
          },
          tooltip: 'Toggle State',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
