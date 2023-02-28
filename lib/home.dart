// ignore_for_file: implementation_imports, unnecessary_import, sort_child_properties_last, unused_local_variable, must_be_immutable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fire_app/crud.dart';
import 'package:fire_app/humidtylist.dart';
import 'package:fire_app/login.dart';
import 'package:fire_app/main.dart';
import 'package:fire_app/services/auth.dart';
import 'package:fire_app/smokeList.dart';
import 'package:fire_app/templist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'linkapi.dart';

class HomePage extends StatefulWidget with Crud {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // const HomePage({super.key});
  final GlobalKey<FormState> _LoginformKey = GlobalKey();

  // TextEditingController temp = TextEditingController();
  final Crud _crud = Crud();

  List temp = [1];
  List hum = [1];
  List smo = [1];

  List last_detection = [0];

  int last_dec = 0;

  num lastTemp = 0;
  num lastHum = 0;
  num lastsmok = 0;

  Future getTemperautre() async {
    var response = await _crud
        .postRequest(linkTempLast, {"id": sharedPref.getString("id")});

    // var responsebody = jsonDecode(response.body);
    return response;
  }

  Stream getTempe() => Stream.periodic(const Duration(seconds: 1))
      .asyncMap((event) => getTemperautre());

  Future getHumidty() async {
    var response = await _crud
        .postRequest(linkHumidtyLast, {"id": sharedPref.getString("id")});
    return response;
  }

  Stream getHum() => Stream.periodic(const Duration(seconds: 1))
      .asyncMap((event) => getHumidty());

  ///
  Future getSmoke() async {
    var response = await _crud
        .postRequest(linkSmokeLast, {"id": sharedPref.getString("id")});
    // var responsebody = jsonDecode(response.body);
    return response;
  }

  Stream getSm() => Stream.periodic(const Duration(seconds: 1))
      .asyncMap((event) => getSmoke());

  @override
  Widget build(BuildContext context) {
    // var temps = [34, 55, 33, 34, 40];
    //var temps = getTemperautre();
    // var lastItem = temps.length - 1;
    // setState(() {
    //   if (temp[0] > 35) {
    //     AwesomeDialog(
    //             context: context,
    //             btnCancel: Text("cances"),
    //             title: "worning",
    //             body: Text("temp is hitgh"))
    //         .show();
    //   }
    // });
    //var temps;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor'),
        actions: [
          IconButton(
              onPressed: () {
                sharedPref.clear();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
        backgroundColor: Colors.purple,
      ),
      body: Container(
        key: _LoginformKey,
        color: Color.fromARGB(255, 82, 255, 232),
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Color.fromARGB(255, 203, 0, 218),
        //       Color(0xFF00CCFF),
        //     ],
        //     begin: FractionalOffset(0.0, 0.0),
        //     end: FractionalOffset(1.0, 1.0),
        //     stops: [0.0, 1.0],
        //     tileMode: TileMode.clamp,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              // ignore: sized_box_for_whitespace
              Expanded(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  child: const Image(
                    image: AssetImage('assets/Security-Alarm-System (1).jpg'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => TempList()));
                              },
                              child: const Center(
                                  child: Text(
                                'Get Temperature',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                            ),
                            height: MediaQuery.of(context).size.height / 25,
                            width: MediaQuery.of(context).size.width / 2.5,
                            color: Colors.purple,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  leading:
                                      const Icon(Icons.thermostat_auto_sharp),

                                  title: StreamBuilder(
                                    stream: getTempe(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        temp.add(snapshot.data['temperature'][0]
                                            ['temp']);
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (timeStamp) {
                                            final temp = snapshot
                                                .data['temperature'][0]['temp'];
                                            if (temp > 30 && temp != lastTemp) {
                                              lastTemp = temp;
                                              AwesomeDialog(
                                                      context: context,
                                                      btnCancel: TextButton(
                                                        child: Text("Cancel"),
                                                        onPressed: Navigator.of(
                                                                context)
                                                            .pop,
                                                      ),
                                                      title: "wornning",
                                                      body:
                                                          Text("temp is hight"))
                                                  .show();
                                              AwesomeNotifications()
                                                  .createNotification(
                                                      content: NotificationContent(
                                                          id: 10,
                                                          channelKey:
                                                              'basic_channel',
                                                          title: 'Temperature',
                                                          body:
                                                              'temp is hight ${lastTemp}'));
                                            }
                                          },
                                        );

                                        return ListView.builder(
                                            itemCount: snapshot
                                                .data['temperature'].length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Text(
                                                  "${snapshot.data['temperature'][index]['temp']} C");

                                              //"${snapshot.data['humidty'][index]['humidty']}");
                                            });

                                        // return Text(
                                        //     "${snapshot.data['temperature'][0]['temp']}c");
                                        // "${snapshot.data['temperature'][index]['temp']}");

                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: Text("loding...."),
                                        );
                                      }
                                      return const Center(
                                        child: Text("loding...."),
                                      );
                                    },
                                  ),
                                  //subtitle: Text('$temps'),

                                  ///
                                  // title: ElevatedButton(
                                  //     onPressed: () async {
                                  //       await Navigator.of(context)
                                  //           .push(MaterialPageRoute(
                                  //               builder: (context) => TempList(
                                  //                   //temps: temps,
                                  //                   )));
                                  //     },
                                  //     child: Text('temps')),
                                  //trailing: Text('${temps[lastItem]}'), //
                                  // trailing: MaterialButton(
                                  //   color: Colors.blue,
                                  //   textColor: Colors.white,
                                  //   padding: EdgeInsets.symmetric(
                                  //       horizontal: 0, vertical: 5),
                                  //   onPressed: () async {
                                  //     await Navigator.of(context).push(
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 TempList()));
                                  //   },
                                  //   child: Text("T"),
                                  // ),

                                  //////////
                                ),
                              ],
                            ),
                            backgroundColor: Colors.white,
                            radius: 60,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HumidtyList()));
                              },
                              child: const Center(
                                  child: Text(
                                'Get Humidty',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                            ),
                            height: MediaQuery.of(context).size.height / 25,
                            width: MediaQuery.of(context).size.width / 2.5,
                            color: Colors.purple,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Column(
                                //   children: [
                                //     SizedBox(
                                //       height: 40,
                                //       width:
                                //           MediaQuery.of(context).size.width / 2.5,
                                //       child: MaterialButton(
                                //         color: Colors.blue,
                                //         textColor: Colors.white,
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 10, vertical: 10),
                                //         onPressed: () async {
                                //           await Navigator.of(context).push(
                                //               MaterialPageRoute(
                                //                   builder: (context) =>
                                //                       const HumidtyList()));
                                //         },
                                //         child: const Text("HumidityList"),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                ListTile(
                                  leading:
                                      const Icon(Icons.water_drop_outlined),
                                  title: StreamBuilder(
                                    stream: getHum(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (timeStamp) {
                                            final hum = snapshot.data['humidty']
                                                [0]['humidty'];
                                            if (hum > 30 && hum != lastHum) {
                                              lastHum = hum;
                                              AwesomeDialog(
                                                      context: context,
                                                      btnCancel: TextButton(
                                                        child: Text("Cancel"),
                                                        onPressed: Navigator.of(
                                                                context)
                                                            .pop,
                                                      ),
                                                      title:
                                                          " humidty wornning",
                                                      body: Text(
                                                          "humidty is hight"))
                                                  .show();
                                              AwesomeNotifications()
                                                  .createNotification(
                                                      content: NotificationContent(
                                                          id: 10,
                                                          channelKey:
                                                              'basic_channel',
                                                          title: 'Humidity',
                                                          body:
                                                              'Humidty is hight ${lastHum}'));
                                            }
                                          },
                                        );
                                        return Text(
                                            "${snapshot.data['humidty'][0]['humidty']}% ");
                                        // "${snapshot.data['temperature'][index]['temp']}");

                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
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
                            backgroundColor: Colors.white,
                            radius: 60,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SmokeList()));
                              },
                              child: const Center(
                                child: Text(
                                  'Smoke Detection',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height / 25,
                            width: MediaQuery.of(context).size.width / 2.5,
                            color: Colors.purple,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StreamBuilder(
                                stream: getSm(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    last_detection.add(
                                        snapshot.data['smoke'][0]['smoke']);
                                    last_dec = last_detection[
                                        last_detection.length - 1];
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                      (timeStamp) {
                                        final smo =
                                            snapshot.data['smoke'][0]['smoke'];
                                        if (smo == 1 && smo != lastsmok) {
                                          lastsmok = smo;
                                          AwesomeDialog(
                                                  context: context,
                                                  btnCancel: TextButton(
                                                    child: Text("Cancel"),
                                                    onPressed:
                                                        Navigator.of(context)
                                                            .pop,
                                                  ),
                                                  title: "wornning",
                                                  body:
                                                      Text("smoke is detected"))
                                              .show();
                                          AwesomeNotifications().createNotification(
                                              content: NotificationContent(
                                                  id: 10,
                                                  channelKey: 'basic_channel',
                                                  title: 'Smoke',
                                                  body:
                                                      'Smoke is  ${lastsmok}'));
                                        }
                                      },
                                    );

                                    // return Text("${snapshot.data['smoke'][0]['smoke']}");
                                    // "${snapshot.data['temperature'][index]['temp']}");
                                    return Column(
                                      children: [
                                        //const Text("not detect"),
                                        last_dec == 0
                                            ? Text("not detect")
                                            : Text("detect"),
                                        CircleAvatar(
                                          backgroundColor: last_dec == 0
                                              ? Colors.green
                                              : Colors.red,
                                          radius: 60,
                                          child: last_dec == 0
                                              //last_dec == "not detect"
                                              ? const Icon(
                                                  Icons.done,
                                                  color: Colors.white,
                                                )
                                              : const Icon(
                                                  Icons.dangerous_rounded,
                                                  color: Colors.white,
                                                ),
                                        )
                                      ],
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: Text("loding...."),
                                    );
                                  }
                                  return const Center(
                                    child: Text("loding...."),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: Container(
              //     child: GestureDetector(
              //       onTap: () async {
              //         await Navigator.of(context).push(MaterialPageRoute(
              //             builder: (context) => const SmokeList()));
              //       },
              //       child: const Center(
              //         child: Text(
              //           'Smoke Detection',
              //           style: TextStyle(
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ),
              //     height: MediaQuery.of(context).size.height / 25,
              //     width: MediaQuery.of(context).size.width / 2,
              //     color: Colors.purple,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),

              //   // ignore: sized_box_for_whitespace
              //   child: Container(
              //     height: 100,
              //     width: MediaQuery.of(context).size.width / 2.4,
              //     child: Column(
              //       children: [
              //         StreamBuilder(
              //           stream: getSm(),
              //           builder: (context, AsyncSnapshot snapshot) {
              //             if (snapshot.hasData) {
              //               last_detection
              //                   .add(snapshot.data['smoke'][0]['smoke']);
              //               last_dec =
              //                   last_detection[last_detection.length - 1];
              //               WidgetsBinding.instance.addPostFrameCallback(
              //                 (timeStamp) {
              //                   final smo = snapshot.data['smoke'][0]['smoke'];
              //                   if (smo == 1 && smo != lastsmok) {
              //                     lastsmok = smo;
              //                     AwesomeDialog(
              //                             context: context,
              //                             btnCancel: TextButton(
              //                               child: Text("Cancel"),
              //                               onPressed:
              //                                   Navigator.of(context).pop,
              //                             ),
              //                             title: "wornning",
              //                             body: Text("smoke is detected"))
              //                         .show();
              //                     AwesomeNotifications().createNotification(
              //                         content: NotificationContent(
              //                             id: 10,
              //                             channelKey: 'basic_channel',
              //                             title: 'Smoke',
              //                             body: 'Smoke is  ${lastsmok}'));
              //                   }
              //                 },
              //               );

              //               // return Text("${snapshot.data['smoke'][0]['smoke']}");
              //               // "${snapshot.data['temperature'][index]['temp']}");
              //               return Column(
              //                 children: [
              //                   //const Text("not detect"),
              //                   last_dec == 0
              //                       ? Text("not detect")
              //                       : Text("detect"),
              //                   CircleAvatar(
              //                     backgroundColor:
              //                         last_dec == 0 ? Colors.green : Colors.red,
              //                     radius:
              //                         MediaQuery.of(context).size.height / 20,
              //                     child: last_dec == 0
              //                         //last_dec == "not detect"
              //                         ? const Icon(
              //                             Icons.done,
              //                             color: Colors.white,
              //                           )
              //                         : const Icon(
              //                             Icons.dangerous_rounded,
              //                             color: Colors.white,
              //                           ),
              //                   )
              //                 ],
              //               );
              //             }
              //             if (snapshot.connectionState ==
              //                 ConnectionState.waiting) {
              //               return const Center(
              //                 child: Text("loding...."),
              //               );
              //             }
              //             return const Center(
              //               child: Text("loding...."),
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Consumer<Auth>(builder: (context, auth, child) {
          if (!auth.authenticated) {
            return ListView(
              children: [
                // ListTile(
                //   title: const Text('LOGIN'),
                //   leading: const Icon(Icons.login),
                //   onTap: () {
                //     Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => LoginPage()));
                //   },
                // ),
                ListTile(
                  title: const Text('Temperature'),
                  leading: const Icon(Icons.thermostat_sharp),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TempList()));
                  },
                ),
                ListTile(
                  title: const Text('Humidty'),
                  leading: const Icon(Icons.water_drop_outlined),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HumidtyList()));
                  },
                ),
                ListTile(
                  title: const Text('Smoke'),
                  leading: const Icon(Icons.air_rounded),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SmokeList()));
                  },
                ),
                // SizedBox(
                //   width: 50,
                //   child: ElevatedButton(
                //       onPressed: () async {
                //         await Navigator.of(context).push(MaterialPageRoute(
                //             builder: (context) => TempList()));
                //       },
                //       child: Text("dd")),
                // )
              ],
            );
          } else {
            return ListView(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        auth.user.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        auth.user.email,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: const Text('LOGOUT'),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).Logout();
                  },
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
