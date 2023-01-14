// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_import, unnecessary_import, duplicate_ignore, prefer_const_constructors, curly_braces_in_flow_control_structures, unnecessary_new, unused_local_variable

import 'dart:math';

import 'package:fire_app/crud.dart';
import 'package:fire_app/home.dart';
import 'package:fire_app/linkapi.dart';
import 'package:fire_app/main.dart';
import 'package:fire_app/templist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports, unused_import
import 'package:flutter/src/widgets/container.dart';
// ignore: implementation_imports, unnecessary_import
import 'package:flutter/src/widgets/framework.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Dashboard extends StatefulWidget with Crud {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //const Dashboard({super.key});
  final Crud _crud = Crud();

  HomePage hh = HomePage();

  List<int> temp = [];
  List<String> temp2 = [];
  List<int> hum = [];
  List<String> hum2 = [];
  List<int> smo = [];
  List<String> smo2 = [];

  Future getTemperautre() async {
    var response =
        await _crud.postRequest(linkTemp, {"id": sharedPref.getString("id")});
    // var responsebody = jsonDecode(response.body);
    return response;
  }

  Stream getTempe() => Stream.periodic(Duration(seconds: 1))
      .asyncMap((event) => getTemperautre());

  Future getHumidty() async {
    var response = await _crud
        .postRequest(linkHumidty, {"id": sharedPref.getString("id")});
    return response;
  }

  Stream getHum() =>
      Stream.periodic(Duration(seconds: 1)).asyncMap((event) => getHumidty());

  ///
  Future getSmoke() async {
    var response =
        await _crud.postRequest(linkSmoke, {"id": sharedPref.getString("id")});
    // var responsebody = jsonDecode(response.body);
    return response;
  }

  Stream getSm() =>
      Stream.periodic(Duration(seconds: 1)).asyncMap((event) => getSmoke());

  // get decoration => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('On Monitor'),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 300,
                child: StreamBuilder(
                  stream: getTempe(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: 1,
                          //shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            for (int i = 0;
                                i < snapshot.data['temperature'].length;
                                i++)
                              temp2.add(
                                  snapshot.data['temperature'][i]['dateTime']);
                            // temp2.add(
                            //   snapshot.data['temperature'][index]['dateTime'],
                            // );
                            for (int i = 0;
                                i < snapshot.data['temperature'].length;
                                i++)
                              temp.add(snapshot.data['temperature'][i]['temp']);
                            return SfCartesianChart(
                              title: ChartTitle(text: 'TEMPRUTER CHART'),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                              ),
                              primaryXAxis: CategoryAxis(),
                              // primaryYAxis: NumericAxis(
                              //   title: AxisTitle(
                              //     text: 'degres',
                              //   ),
                              //   labelFormat: '{value} C',
                              // ),
                              // legend: Legend(
                              //   isVisible: true,
                              // ),
                              series: <ChartSeries>[
                                StackedColumnSeries<ChartData, String>(
                                    dataSource: <ChartData>[
                                      for (int i = 0;
                                          i <
                                              snapshot
                                                  .data['temperature'].length;
                                          i++)
                                        ChartData(x: temp2[i], y1: temp[i])
                                      // ChartData(x: temp2[0], y1: temp[0]),
                                      // ChartData(x: temp2[1], y1: temp[1]),
                                      // ChartData(x: temp2[2], y1: temp[2]),
                                      // ChartData(x: temp2[3], y1: temp[3]),
                                      // ChartData(x: temp2[4], y1: temp[4]),
                                      // ChartData(x: temp2[5], y1: temp[5]),
                                      // ChartData(x: temp2[6], y1: temp[6]),

                                      //for(int i=0;i<=temp.length;i++)
                                      //ChartData(x: temp2[0], y1: temp[0])
                                    ],
                                    xValueMapper: (ChartData ch, _) => ch.x,
                                    yValueMapper: (ChartData ch, _) => ch.y1),
                              ],
                            );
                          }));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text("loding...."),
                      );
                    }
                    return const Center(
                      child: Text("loding...."),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 300,
                child: StreamBuilder(
                  stream: getHum(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: 1,
                          //shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            for (int i = 0;
                                i < snapshot.data['humidty'].length;
                                i++)
                              hum2.add(snapshot.data['humidty'][i]['dateTime']);
                            // temp2.add(
                            //   snapshot.data['temperature'][index]['dateTime'],
                            // );
                            for (int i = 0;
                                i < snapshot.data['humidty'].length;
                                i++)
                              hum.add(snapshot.data['humidty'][i]['humidty']);
                            return SfCartesianChart(
                              title: ChartTitle(text: 'HUMIDTY CHART'),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                              ),
                              primaryXAxis: CategoryAxis(),
                              // primaryYAxis: NumericAxis(
                              //   title: AxisTitle(
                              //     text: 'degres',
                              //   ),
                              //   labelFormat: '{value} C',
                              // ),
                              // legend: Legend(
                              //   isVisible: true,
                              // ),
                              series: <ChartSeries>[
                                StackedColumnSeries<humchart, String>(
                                    dataSource: <humchart>[
                                      for (int i = 0;
                                          i < snapshot.data['humidty'].length;
                                          i++)
                                        humchart(x: hum2[i], y1: hum[i])
                                      // ChartData(x: temp2[0], y1: temp[0]),
                                      // ChartData(x: temp2[1], y1: temp[1]),
                                      // ChartData(x: temp2[2], y1: temp[2]),
                                      // ChartData(x: temp2[3], y1: temp[3]),
                                      // ChartData(x: temp2[4], y1: temp[4]),
                                      // ChartData(x: temp2[5], y1: temp[5]),
                                      // ChartData(x: temp2[6], y1: temp[6]),

                                      //for(int i=0;i<=temp.length;i++)
                                      //ChartData(x: temp2[0], y1: temp[0])
                                    ],
                                    xValueMapper: (humchart ch, _) => ch.x,
                                    yValueMapper: (humchart ch, _) => ch.y1),
                              ],
                            );
                          }));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text("loding...."),
                      );
                    }
                    return const Center(
                      child: Text("loding...."),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 300,
                child: StreamBuilder(
                  stream: getSm(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: 1,
                          //shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            for (int i = 0;
                                i < snapshot.data['smoke'].length;
                                i++)
                              smo2.add(snapshot.data['smoke'][i]['dateTime']);
                            // temp2.add(
                            //   snapshot.data['temperature'][index]['dateTime'],
                            // );
                            for (int i = 0;
                                i < snapshot.data['smoke'].length;
                                i++)
                              smo.add(snapshot.data['smoke'][i]['smoke']);
                            return SfCartesianChart(
                              title: ChartTitle(text: 'SMOKE CHART'),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                              ),
                              primaryXAxis: CategoryAxis(),
                              // primaryYAxis: NumericAxis(
                              //   title: AxisTitle(
                              //     text: 'degres',
                              //   ),
                              //   labelFormat: '{value} C',
                              // ),
                              // legend: Legend(
                              //   isVisible: true,
                              // ),
                              series: <ChartSeries>[
                                StackedColumnSeries<smoChart, String>(
                                    dataSource: <smoChart>[
                                      for (int i = 0;
                                          i < snapshot.data['smoke'].length - 1;
                                          i++)
                                        smoChart(x: smo2[i], y1: smo[i])
                                      // ChartData(x: temp2[0], y1: temp[0]),
                                      // ChartData(x: temp2[1], y1: temp[1]),
                                      // ChartData(x: temp2[2], y1: temp[2]),
                                      // ChartData(x: temp2[3], y1: temp[3]),
                                      // ChartData(x: temp2[4], y1: temp[4]),
                                      // ChartData(x: temp2[5], y1: temp[5]),
                                      // ChartData(x: temp2[6], y1: temp[6]),

                                      //for(int i=0;i<=temp.length;i++)
                                      //ChartData(x: temp2[0], y1: temp[0])
                                    ],
                                    xValueMapper: (smoChart ch, _) => ch.x,
                                    yValueMapper: (smoChart ch, _) => ch.y1),
                              ],
                            );
                          }));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text("loding...."),
                      );
                    }
                    return const Center(
                      child: Text("loding...."),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class ChartData {
  var x;
  var y1;

  ChartData({
    required this.x,
    required this.y1,
  });
}

class humchart {
  var x;
  var y1;

  humchart({
    required this.x,
    required this.y1,
  });
}

class smoChart {
  var x;
  var y1;

  smoChart({
    required this.x,
    required this.y1,
  });
}
// class ChartData {
//   final String x;
//   final int y1;
//   final int y2;
//   final int y3;
//   final int y4;
//   ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
// }

// class TT {
//   final int temp;
//   final String date;
//   TT(this.temp, this.date);
// }

// TempData() {
//   List<tdata> tt = <tdata>[
//     // HomePage().temp,
//   ];
// }

// class tdata {
//   int x, y;
//   tdata(this.x, this.y);
// }

class SalesData {
  double x, y;
  SalesData(
    this.x,
    this.y,
  );
}

dynamic getColumnData() {
  // Crud _crud = Crud();
  // List ylist =
  //     await _crud.postRequest(linkTemp, {"id": sharedPref.getString("id")});
  // List x = [10, 20, 30, 40];

  // Future getTemperautre() async {
  //   var mylist =
  //       await _crud.postRequest(linkTemp, {"id": sharedPref.getString("id")});
  //   // var responsebody = jsonDecode(response.body);
  //   return mylist;
  // }

//   List<SalesData> columnData = <SalesData>[
//     for (int i = 0; i <= 4; i++) SalesData(ylist[i], x[i]),
//   ];
//   return columnData;
// }
  List<SalesData> columnData = <SalesData>[
    SalesData(5, 35),
    SalesData(10, 33),
    SalesData(15, 50),
    SalesData(20, 30),
  ];
  return columnData;
}

// dynamic getHugeData() {
//   List<SalesData> hugeData = <SalesData>[];
//   double value = 35;
//   Random rand = new Random();

//   for (int i = 0; i < 60; i++) {
//     if (rand.nextDouble() > 0.5)
//       value += rand.nextDouble();
//     else
//       value -= rand.nextDouble();

//     hugeData.add(SalesData(i.toDouble(), value));
//   }
//   return hugeData;
// }

// ignore: camel_case_types
// class Task {
//   String task;
//   String taskValue;
//   Color colorValue;
//   Task(this.task, this.taskValue, this.colorValue);
// }

// ignore: non_constant_identifier_names
