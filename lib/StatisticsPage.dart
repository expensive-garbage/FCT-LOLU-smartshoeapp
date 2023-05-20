import 'dart:math';

import 'package:flutter/material.dart';
import 'package:namer_app/MyApp.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => StatisticsPageState();
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class StatisticsPageState extends State<StatisticsPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  List<QueryDocumentSnapshot> shoesList = [];
  final Random random = Random();
  List<Tab> tabs = [];
  List<SingleChildScrollView> childrenStats = [];
  List<double> humidityAverages = [];
  Map<String, double> dataMap = {};
  List<Color> colorslist = [];

  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
    getShoesData();
  }

  Future<void> getShoesData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('shoe')
        .where('IdUser', isEqualTo: user?.uid)
        .get();

    for (QueryDocumentSnapshot shoe in shoesList) {
      QuerySnapshot<Map<String, dynamic>> shoeDataSnapshot =
          await FirebaseFirestore.instance
              .collection('shoedata')
              .where('shoeId', isEqualTo: shoe.id)
              .get();

      List<QueryDocumentSnapshot> shoeDataList = shoeDataSnapshot.docs;
      double averageHumidity = calculateAverageHumidity(shoeDataList);
      humidityAverages.add(averageHumidity);
    }

    setState(() {
      shoesList = querySnapshot.docs;
      tabs = generateTabsFromShoesList(shoesList);
      childrenStats = generateChildrenFromShoesList(shoesList);
      dataMap= generateDataMap();
      colorslist= generateRandomColors();
    });
  }

  double calculateAverageHumidity(List<QueryDocumentSnapshot> shoeDataList) {
    int totalHumidity = 0;
    int count = 0;

    for (QueryDocumentSnapshot shoeData in shoeDataList) {
      int humidity = shoeData['humidity'];
      totalHumidity += humidity;
      count++;
    }

    if (count > 0) {
      return totalHumidity / count;
    } else {
      return 0;
    }
  }

  List<Tab> generateTabsFromShoesList(List<QueryDocumentSnapshot> shoesList) {
    return List.generate(shoesList.length, (index) {
      return Tab(
        text: shoesList[index]['Name'],
      );
    });
  }

  List<SingleChildScrollView> generateChildrenFromShoesList(
      List<QueryDocumentSnapshot> shoesList) {
    return List.generate(shoesList.length, (index) {
      return SingleChildScrollView(
        child: Text(shoesList[index]['Name']),
      );
    });
  }

  Map<String, double> generateDataMap() {

    shoesList.forEach((shoe) {
      int randomValue = random.nextInt(20); // Génère un nombre aléatoire entre 0 et 100
      dataMap[shoe['Name']] = randomValue as double;
    });

    return dataMap;
  }

  List<Color> generateRandomColors() {

    for (int i = 0; i < shoesList.length; i++) {
      Color color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0,
      );
      colorslist.add(color);
    }

    return colorslist;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return MaterialApp(
        home: DefaultTabController(
      length: shoesList.length + 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: [
            const Tab(text: 'Overview'),
            for (Tab tab in tabs) tab,
          ]),
          title: const Text('Statistics'),
          backgroundColor: const Color.fromARGB(255, 4, 104, 130),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Action souhaitée lors de l'appui sur le bouton flèche
              // Par exemple, pour revenir à l'écran précédent :
              appState.changeIndexProfilePage(0);
            },
          ),
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PieChart(
                      dataMap: dataMap,
                      chartType: ChartType.disc,
                      ringStrokeWidth: 6,
                      baseChartColor: Colors.grey[300]!,
                      colorList: colorslist,
                    ),
                  ),
                  const Text('Wearing days of each shoes',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 16),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      height: 200,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries>[
                          LineSeries<ChartData, String>(
                              dataSource: [
                                ChartData('Day 1', 0.2),
                                ChartData('Day 2', 0.8),
                                ChartData('Day 3', 0.6),
                                ChartData('Day 4', 0.3)
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y)
                        ],
                      )),
                  const Text('Humidity Rate',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ),
          for (SingleChildScrollView child in childrenStats) child,
        ]),
      ),
    ));
  }
}
