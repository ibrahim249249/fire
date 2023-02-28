// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:fire_app/crud.dart';
import 'package:fire_app/linkapi.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports, unnecessary_import
import 'package:flutter/src/widgets/container.dart';
// ignore: implementation_imports, unnecessary_import
import 'package:flutter/src/widgets/framework.dart';

import 'main.dart';

enum Monitor { humidity, temperature, smoke }

class Preiodic extends StatefulWidget with Crud {
  const Preiodic({super.key});

  @override
  State<Preiodic> createState() => _PreiodicState();
}

class _PreiodicState extends State<Preiodic> {
  final Crud _crud = Crud();
  Monitor? _monitor;
  List<int> humidty = [];
  List<String> humidty2 = [];
  List<int> temp = [];
  List<String> temp2 = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm cases'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 203, 0, 218),
              Color(0xFF00CCFF),
            ],
            begin: FractionalOffset(0.0, 1.0),
            end: FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView(
          children: [
            Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(Monitor.humidity.name),
                      leading: Radio<Monitor>(
                        value: Monitor.humidity,
                        groupValue: _monitor,
                        onChanged: (value) {
                          setState(() {
                            _monitor = Monitor.humidity;
                            //if (_monitor != null)
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(Monitor.temperature.name),
                      leading: Radio<Monitor>(
                        value: Monitor.temperature,
                        groupValue: _monitor,
                        onChanged: (value) {
                          setState(() {
                            _monitor = value;
                            // if (_monitor != null)
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(Monitor.smoke.name),
                      leading: Radio<Monitor>(
                        value: Monitor.smoke,
                        groupValue: _monitor,
                        onChanged: (value) {
                          setState(() {
                            _monitor = value;
                            //if (_monitor != null)
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_monitor == Monitor.smoke)
              (Container(
                height: MediaQuery.of(context).size.height,
                child: (FutureBuilder(
                        future: getSmoke(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Text("loding...."),
                            );
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            return ListView.builder(
                                itemCount: 1,
                                itemBuilder: ((context, index) {
                                  //Map map = snapshot.data;

                                  for (int i = 0;
                                      i < snapshot.data['smoke'].length;
                                      i++) {
                                    if (snapshot.data['smoke'][i]['smoke'] == 1)
                                      smo2.add(snapshot.data['smoke'][i]
                                          ['dateTime']);
                                  }
                                  ;

                                  for (int i = 0;
                                      i < snapshot.data['smoke'].length;
                                      i++) {
                                    if (snapshot.data['smoke'][i]['smoke'] == 1)
                                      smo.add(
                                          snapshot.data['smoke'][i]['smoke']);
                                  }
                                  ;
                                  return SingleChildScrollView(
                                    child: Card(
                                      child: Center(
                                        child: Table(
                                          border: TableBorder.all(),
                                          columnWidths: {
                                            0: FractionColumnWidth(0.15),
                                            2: FractionColumnWidth(0.50),
                                            3: FractionColumnWidth(0.5),
                                          },
                                          children: [
                                            buildRow(
                                                ['id', 'Smoke', 'DateTime'],
                                                isHeader: true),
                                            for (int i = 0; i < smo.length; i++)
                                              buildRow([
                                                '${i}',
                                                'detected',
                                                '${smo2[i]}'
                                              ]),
                                            // buildRow(['Ahmed', 'usa', '20']),
                                            // buildRow(['Ali', 'us', '23']),
                                          ],
                                        ),
                                      ),
                                      // child: ListTile(
                                      //   leading: const Image(
                                      //     image: AssetImage(
                                      //         'assets/use_no_woter.png'),
                                      //   ),
                                      //   title: Expanded(
                                      //     child: Column(
                                      //       children: [
                                      //         for (int i = 0;
                                      //             i < humidty.length &&
                                      //                 i < humidty2.length;
                                      //             i++)
                                      //           Text(
                                      //               " Humidity is : ${humidty[i]}     ${"                     "}             dateTime : ${humidty2[i]}")
                                      //       ],
                                      //     ),
                                      //   ),
                                      //   // title: snapshot.connectionState ==
                                      //   //         ConnectionState.waiting
                                      //   //     ? Center(child: Text("loding...."))
                                      //   //     : Text(
                                      //   //         "value : Humidity is ${snapshot.data['humidty'][0]['humidty']}"),
                                      //   // subtitle: Text(
                                      //   //     " Date and time : ${snapshot.data['humidty'][0]['dateTime']}"),
                                      // ),
                                    ),
                                  );
                                }));
                          }

                          return const Center(
                            child: Text("loding...."),
                          );
                        })
                    // Card(
                    //   child: ListTile(
                    //     leading: FlutterLogo(),
                    //     title: ,
                    //   ),
                    //   // child: ListTile(
                    //   //   leading: FlutterLogo(),
                    //   //   title: Text('Value : detect '),
                    //   //   subtitle: Text('Date And Time : 8/7/2022'),
                    //   // ),
                    // )
                    ),
              ))
            else if (_monitor == Monitor.temperature)
              (Container(
                height: MediaQuery.of(context).size.height,
                child: (FutureBuilder(
                    future: getTemperautre(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("loding...."),
                        );
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              for (int i = 0;
                                  i < snapshot.data['temperature'].length;
                                  i++) {
                                if (snapshot.data['temperature'][i]['temp'] >
                                    30)
                                  temp2.add(snapshot.data['temperature'][i]
                                      ['dateTime']);
                              }
                              ;

                              for (int i = 0;
                                  i < snapshot.data['temperature'].length;
                                  i++) {
                                if (snapshot.data['temperature'][i]['temp'] >
                                    30)
                                  temp.add(
                                      snapshot.data['temperature'][i]['temp']);
                              }
                              ;
                              //int i = 0;
                              return SingleChildScrollView(
                                child: Card(
                                  child: Center(
                                    child: Table(
                                      border: TableBorder.all(),
                                      columnWidths: {
                                        0: FractionColumnWidth(0.15),
                                        2: FractionColumnWidth(0.50),
                                        3: FractionColumnWidth(0.5),
                                      },
                                      children: [
                                        buildRow(
                                            ['id', 'Temperature', 'DateTime'],
                                            isHeader: true),
                                        for (int i = 0; i < temp.length; i++)
                                          buildRow([
                                            '${i}',
                                            '${temp[i]}',
                                            '${temp2[i]}'
                                          ]),
                                        // buildRow(['Ahmed', 'usa', '20']),
                                        // buildRow(['Ali', 'us', '23']),
                                      ],
                                    ),
                                  ),
                                  // child: ListTile(
                                  //   leading: const Image(
                                  //     image: AssetImage(
                                  //         'assets/use_no_woter.png'),
                                  //   ),
                                  //   title: Expanded(
                                  //     child: Column(
                                  //       children: [
                                  //         for (int i = 0;
                                  //             i < humidty.length &&
                                  //                 i < humidty2.length;
                                  //             i++)
                                  //           Text(
                                  //               " Humidity is : ${humidty[i]}     ${"                     "}             dateTime : ${humidty2[i]}")
                                  //       ],
                                  //     ),
                                  //   ),
                                  //   // title: snapshot.connectionState ==
                                  //   //         ConnectionState.waiting
                                  //   //     ? Center(child: Text("loding...."))
                                  //   //     : Text(
                                  //   //         "value : Humidity is ${snapshot.data['humidty'][0]['humidty']}"),
                                  //   // subtitle: Text(
                                  //   //     " Date and time : ${snapshot.data['humidty'][0]['dateTime']}"),
                                  // ),
                                ),
                              );
                            });
                      }
                      ;

                      return const Center(
                        child: Text("loding...."),
                      );
                    })),
              ))
            else if (_monitor == Monitor.humidity)
              SingleChildScrollView(
                child: (Container(
                    height: MediaQuery.of(context).size.height,
                    child: (FutureBuilder(
                        future: getHumidty(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Text("loding...."),
                            );
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            return ListView.builder(
                                itemCount: 1,
                                itemBuilder: ((context, index) {
                                  for (int i = 0;
                                      i < snapshot.data['humidty'].length;
                                      i++) {
                                    if (snapshot.data['humidty'][i]['humidty'] >
                                        30) {
                                      humidty2.add(snapshot.data['humidty'][i]
                                          ['dateTime']);
                                      humidty.add(snapshot.data['humidty'][i]
                                          ['humidty']);
                                    }
                                  }
                                  ;

                                  // for (int i = 0;
                                  //     i < snapshot.data['humidty'].length;
                                  //     i++) {
                                  //   if (snapshot.data['humidty'][i]['humidty'] >
                                  //       30)
                                  //     humidty.add(snapshot.data['humidty'][i]
                                  //         ['humidty']);
                                  // }
                                  ;
                                  return SingleChildScrollView(
                                    child: Card(
                                      child: Center(
                                        child: Table(
                                          border: TableBorder.all(),
                                          columnWidths: {
                                            0: FractionColumnWidth(0.15),
                                            2: FractionColumnWidth(0.50),
                                            3: FractionColumnWidth(0.5),
                                          },
                                          children: [
                                            buildRow(
                                                ['id', 'Humidity', 'DateTime'],
                                                isHeader: true),
                                            for (int i = 0;
                                                i < humidty.length;
                                                i++)
                                              buildRow([
                                                '${i}',
                                                '${humidty[i]}',
                                                '${humidty2[i]}'
                                              ]),
                                            // buildRow(['Ahmed', 'usa', '20']),
                                            // buildRow(['Ali', 'us', '23']),
                                          ],
                                        ),
                                      ),
                                      // child: ListTile(
                                      //   leading: const Image(
                                      //     image: AssetImage(
                                      //         'assets/use_no_woter.png'),
                                      //   ),
                                      //   title: Expanded(
                                      //     child: Column(
                                      //       children: [
                                      //         for (int i = 0;
                                      //             i < humidty.length &&
                                      //                 i < humidty2.length;
                                      //             i++)
                                      //           Text(
                                      //               " Humidity is : ${humidty[i]}     ${"                     "}             dateTime : ${humidty2[i]}")
                                      //       ],
                                      //     ),
                                      //   ),
                                      //   // title: snapshot.connectionState ==
                                      //   //         ConnectionState.waiting
                                      //   //     ? Center(child: Text("loding...."))
                                      //   //     : Text(
                                      //   //         "value : Humidity is ${snapshot.data['humidty'][0]['humidty']}"),
                                      //   // subtitle: Text(
                                      //   //     " Date and time : ${snapshot.data['humidty'][0]['dateTime']}"),
                                      // ),
                                    ),
                                  );
                                }));
                          }

                          return const Center(
                            child: Text("loding...."),
                          );
                        })))),
              )

            //   if (_monitor != null)
            //     const Card(
            //       child: ListTile(
            //         leading: FlutterLogo(),
            //         title: Text('Value : 35 '),
            //         subtitle: Text('Date And Time : 8/7/2022'),
            //       ),
            //     )

            else
              SizedBox()
          ],
        ),
      ),
    );
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
          children: cells.map((cell) {
        final style = TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 18,
        );
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Text(
              cell,
              style: style,
            ),
          ),
        );
      }).toList());
}
