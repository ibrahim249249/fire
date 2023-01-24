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

  Future getTemperautre() async {
    var response = await _crud
        .postRequest(linkTempLast, {"id": sharedPref.getString("id")});
    // var responsebody = jsonDecode(response.body);
    return response;
  }

  Stream getTempe() => Stream.periodic(Duration(seconds: 1))
      .asyncMap((event) => getTemperautre());

  Future getHumidty() async {
    var response = await _crud
        .postRequest(linkHumidtyLast, {"id": sharedPref.getString("id")});
    return response;
  }

  Stream getHum() =>
      Stream.periodic(Duration(seconds: 1)).asyncMap((event) => getHumidty());

  ///
  Future getSmoke() async {
    var response = await _crud
        .postRequest(linkSmokeLast, {"id": sharedPref.getString("id")});
    // var responsebody = jsonDecode(response.body);
    return response;
  }

  Stream getSm() =>
      Stream.periodic(Duration(seconds: 1)).asyncMap((event) => getSmoke());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On Monitor'),
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
                height: 60,
                child: (StreamBuilder(
                        stream: getSm(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return ListView.builder(
                                itemCount: 700,
                                itemBuilder: ((context, index) {
                                  return Card(
                                    child: ListTile(
                                      leading: FlutterLogo(),
                                      title: Text(
                                          "value : ${snapshot.data['smoke'][0]['smoke']}"),
                                      subtitle: Text(
                                          " Date and time : ${snapshot.data['smoke'][0]['dateTime']}"),
                                    ),
                                  );
                                }));
                          }
                          ;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Text("loding...."),
                            );
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
                height: 60,
                child: (StreamBuilder(
                    stream: getTempe(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView.builder(
                            itemCount: 700,
                            itemBuilder: ((context, index) {
                              return Card(
                                child: ListTile(
                                  leading: FlutterLogo(),
                                  title: Text(
                                      "value : ${snapshot.data['temperature'][0]['temp']}"),
                                  subtitle: Text(
                                      " Date and time : ${snapshot.data['temperature'][0]['dateTime']}"),
                                ),
                              );
                            }));
                      }
                      ;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("loding...."),
                        );
                      }
                      return const Center(
                        child: Text("loding...."),
                      );
                    })),
              ))
            else if (_monitor == Monitor.humidity)
              (Container(
                  height: 60,
                  child: (StreamBuilder(
                      stream: getHum(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return ListView.builder(
                              itemCount: 700,
                              itemBuilder: ((context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: FlutterLogo(),
                                    title: snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? Center(child: Text("loding...."))
                                        : Text(
                                            "value : ${snapshot.data['humidty'][0]['humidty']}"),
                                    subtitle: Text(
                                        " Date and time : ${snapshot.data['humidty'][0]['dateTime']}"),
                                  ),
                                );
                              }));
                        }
                        ;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Text("loding...."),
                          );
                        }
                        return const Center(
                          child: Text("loding...."),
                        );
                      }))))

            //   if (_monitor != null)
            //     const Card(
            //       child: ListTile(
            //         leading: FlutterLogo(),
            //         title: Text('Value : 35 '),
            //         subtitle: Text('Date And Time : 8/7/2022'),
            //       ),
            //     )
          ],
        ),
      ),
    );
  }
}
