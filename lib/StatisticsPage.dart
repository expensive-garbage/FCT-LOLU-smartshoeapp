import 'dart:math';

import 'package:flutter/material.dart';
import 'package:namer_app/MyApp.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);
  @override
  State<StatisticsPage> createState() => StatisticsPageState();
}

class ColorsShoeData {
  ColorsShoeData(this.color, this.count);
  final String color;
  final int? count;
}

class HumidityShoeData {
  HumidityShoeData(this.rate, this.index);
  final double rate;
  final int index;
}

class StatisticsPageState extends State<StatisticsPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/home');
    }
  }

  List<QueryDocumentSnapshot> shoesListbis = [];
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

    setState(() {
      shoesListbis = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    String uid = appState.uid;

    final Stream<QuerySnapshot> shoesStreamNC = FirebaseFirestore.instance
        .collection('shoe')
        .where('IdUser', isEqualTo: uid)
        .snapshots();

    final Stream<QuerySnapshot> shoesDataStream = FirebaseFirestore.instance
        .collection('shoeData')
        .where('IDofShoe', isEqualTo: 'SGKmxDDB2shwdsQ5Grzf')
        .snapshots();

    return MaterialApp(
        home: DefaultTabController(
      length: shoesListbis.length + 1,
      child: StreamBuilder<QuerySnapshot>(
          stream: shoesStreamNC,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Text('An error occurred');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No matching shoes');
            } else {
              final Shoes = snapshot.data!;
              List<QueryDocumentSnapshot> shoesList = Shoes.docs;

              List<Tab> tabs = List.generate(shoesList.length, (index) {
                return Tab(
                  text: shoesList[index]['Name'],
                );
              });

              List<SingleChildScrollView> childrenStats =
                  List.generate(shoesList.length, (index) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                              'The last time you wore your ${shoesList[index]['Name']} was on ${shoesList[index]['DateLastWorn'].toString()}'),
                          StreamBuilder<QuerySnapshot>(
                            stream: shoesDataStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                print('Error: ${snapshot.error}');
                                return Text('An error occurred');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Text('No matching data');
                              } else {
                                final ShoeData = snapshot.data!;
                                List<QueryDocumentSnapshot> shoesDataList =
                                    ShoeData.docs;
                                List<double> humidityRates = List.generate(
                                    shoesDataList.length, (index) {
                                  return shoesDataList[index]['humidity'];
                                });
                                List<HumidityShoeData> chartHumidityData = [];

                                List<HumidityShoeData>
                                    generateChartHumidityData(
                                        List<double> humidityRates) {
                                  List<HumidityShoeData> chartHumidityData = [];
                                  int i = 0;
                                  humidityRates.forEach((humidity) {
                                    chartHumidityData
                                        .add(HumidityShoeData(humidity, i));
                                    i += 1;
                                  });
                                  return chartHumidityData;
                                }

                                chartHumidityData =
                                    generateChartHumidityData(humidityRates);

                                return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    width: double.infinity,
                                    height: 200,
                                    child: SfCartesianChart(
                                      primaryXAxis: CategoryAxis(),
                                      series: <
                                          ChartSeries<HumidityShoeData, int>>[
                                        ColumnSeries<HumidityShoeData, int>(
                                          dataSource: chartHumidityData,
                                          xValueMapper:
                                              (HumidityShoeData data, _) =>
                                                  data.index,
                                          yValueMapper:
                                              (HumidityShoeData data, _) =>
                                                  data.rate,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true),
                                        )
                                      ],
                                    ));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });

              final Random random = Random();
              List<Color> colorslist = [];
              Map<String, double> brandCount = {};
              Map<String, double> generateDataMapBrand() {
                shoesList.forEach((shoe) {
                  String brand = shoe['Brand'];
                  brandCount[brand] = (brandCount[brand] ?? 0) + 1;
                });
                return brandCount;
              }

              brandCount = generateDataMapBrand();

              String favouriteType = '';

              String getMostFrequentType(
                  List<QueryDocumentSnapshot> shoesList) {
                Map<String, int> typeCount = {};
                shoesList.forEach((shoe) {
                  String type = shoe['Type'];
                  typeCount[type] = (typeCount[type] ?? 0) + 1;
                });

                int maxCount = 0;
                typeCount.forEach((type, count) {
                  if (count > maxCount) {
                    maxCount = count;
                    favouriteType = type;
                  }
                });

                return favouriteType;
              }

              favouriteType = getMostFrequentType(shoesList);
              """
              Map<String, int> frequencyColors = {};

              Map<String, int> getFrequencyColors(
                  List<QueryDocumentSnapshot> shoesList) {
                shoesList.forEach((shoe) {
                  List<String> colors = shoe['Colors'];
                  print(colors);
                  for (String color in colors) {
                    if (color != 'null') {
                      frequencyColors[color] =
                          (frequencyColors[color] ?? 0) + 1;
                    }
                  }
                });
                return frequencyColors;
              }

              frequencyColors = getFrequencyColors(shoesList);
              print(frequencyColors);
              """;
              List<ColorsShoeData> chartData = [
                ColorsShoeData('yellow', 3),
                ColorsShoeData('blue', 5),
                ColorsShoeData('black', 6)
              ];
              """
              List<ColorsShoeData> generateChartData(
                  Map<String, int> frequencyColors) {
                frequencyColors.forEach((color, frequency) {
                  chartData.add(ColorsShoeData(color, frequency));
                });
                return chartData;
              }
              chartData = generateChartData(frequencyColors);
              """;
              List<Color> generateRandomColors() {
                for (int i = 0; i < brandCount.length; i++) {
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

              colorslist = generateRandomColors();
              return Scaffold(
                appBar: AppBar(
                  bottom: TabBar(isScrollable: true, tabs: [
                    const Tab(text: 'Overview'),
                    for (Tab tab in tabs) tab,
                  ]),
                  title: const Text('Statistics'),
                  backgroundColor: const Color.fromARGB(255, 4, 104, 130),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          const Text('Number of shoes by brand',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: PieChart(
                              dataMap: brandCount,
                              chartType: ChartType.disc,
                              ringStrokeWidth: 6,
                              baseChartColor: Colors.grey[300]!,
                              colorList: colorslist,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('Your favorite type of shoes is $favouriteType',
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              width: double.infinity,
                              height: 200,
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                series: <ChartSeries<ColorsShoeData, String>>[
                                  ColumnSeries<ColorsShoeData, String>(
                                    dataSource: chartData,
                                    xValueMapper: (ColorsShoeData data, _) =>
                                        data.color,
                                    yValueMapper: (ColorsShoeData data, _) =>
                                        data.count,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true),
                                  )
                                ],
                              )),
                          const Text('Frequency of each color',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal)),
                          const SizedBox(height: 16),
                        ]),
                      ),
                    ),
                  ),
                  for (SingleChildScrollView child in childrenStats) child,
                ]),
              );
            }
          }),
    ));
  }
}
