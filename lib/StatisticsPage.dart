import 'package:flutter/material.dart';
import 'package:namer_app/MyApp.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  final int id = 0;

  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/home');
    }
  }

  final dataMap = <String, double>{
    "Veja": 5,
    "Nike Dunk": 3,
    "Converse": 7,
  };

  final colorList = <Color>[
    Colors.red,
    Colors.amber,
    const Color.fromARGB(66, 98, 111, 221),
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    int currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 4, 104, 130),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Action souhaitée lors de l'appui sur le bouton flèche
            // Par exemple, pour revenir à l'écran précédent :
            appState.changeIndexProfilePage(0);
          },
        ),
      ),
      body: SingleChildScrollView(
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
                  colorList: colorList,
                ),
              ),
              const Text('Wearing days of each shoes',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
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
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ),
    );
  }
}
