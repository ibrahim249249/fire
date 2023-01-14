// ignore_for_file: implementation_imports, unnecessary_import, sort_child_properties_last, unused_local_variable, must_be_immutable

import 'package:fire_app/crud.dart';
import 'package:fire_app/humidtylist.dart';
import 'package:fire_app/login.dart';
import 'package:fire_app/main.dart';
import 'package:fire_app/services/auth.dart';
import 'package:fire_app/templist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'linkapi.dart';

class HomePage extends StatelessWidget with Crud {
  // const HomePage({super.key});
  final GlobalKey<FormState> _LoginformKey = GlobalKey();

  // TextEditingController temp = TextEditingController();

  // getTemp() async {
  //   var response = await getTemp(linkTemp, {"id": sharedPref.getString("id ")});
  // }
  final Crud _crud = Crud();
  List temp = [1];
  List last_detection = [0];
  int last_dec = 0;

  HomePage({super.key});
  Future getTemperautre() async {
    var response = await _crud
        .postRequest(linkTempLast, {"id": sharedPref.getString("id")});
    // var responsebody = jsonDecode(response.body);
    return response;
  }

  Stream getTempe() => Stream.periodic(const Duration(seconds: 1))
      .asyncMap((event) => getTemperautre());

  Future getHumidty() async {
    var response =
        await postRequest(linkHumidtyLast, {"id": sharedPref.getString("id")});
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
    var temps = [34, 55, 33, 34, 40];
    //var temps = getTemperautre();
    var lastItem = temps.length - 1;
    //var temps;
    return Scaffold(
      appBar: AppBar(
        title: const Text('On Monitor'),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 203, 0, 218),
              Color(0xFF00CCFF),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView(
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              height: 200,
              child: const Image(
                image: AssetImage('assets/Security-Alarm-System (1).jpg'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
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
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Card(
                          //margin: const EdgeInsets.all(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: MaterialButton(
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      onPressed: () async {
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TempList()));
                                      },
                                      child: const Text("TempList"),
                                    ),
                                  ),
                                  ListTile(
                                    leading:
                                        const Icon(Icons.thermostat_auto_sharp),
                                    // trailing: MaterialButton(
                                    //   color: Colors.blue,
                                    //   textColor: Colors.white,
                                    //   padding: EdgeInsets.symmetric(
                                    //       horizontal: 10, vertical: 10),
                                    //   onPressed: () async {
                                    //     await Navigator.of(context).push(
                                    //         MaterialPageRoute(
                                    //             builder: (context) => TempList()));
                                    //   },
                                    //   child: Text("T"),
                                    // ),
                                    title: StreamBuilder(
                                      stream: getTempe(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          temp.add(snapshot.data['temperature']
                                              [0]['temp']);
                                          return ListView.builder(
                                              itemCount: snapshot
                                                  .data['temperature'].length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Text(
                                                    "${snapshot.data['temperature'][index]['temp']}c");
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
                            ],
                          ),
                        ),
                        // child: const Card(
                        //   child: Icon(
                        //     Icons.thermostat_auto_sharp,
                        //   ),
                        // ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const HumidtyList()));
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
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Card(
                          //margin: const EdgeInsets.all(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: MaterialButton(
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      onPressed: () async {
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HumidtyList()));
                                      },
                                      child: const Text("HumidityList"),
                                    ),
                                  ),
                                ],
                              ),
                              ListTile(
                                leading: const Icon(Icons.water_drop_outlined),
                                title: StreamBuilder(
                                  stream: getHum(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                          "${snapshot.data['humidty'][0]['humidty']}c");
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
                        ),
                        // child: const Card(
                        //   child: Icon(Icons.water_drop_outlined),
                        // ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: const Center(
                  child: Text(
                    'Smoke Detection',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                height: MediaQuery.of(context).size.height / 25,
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.purple,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),

              // ignore: sized_box_for_whitespace
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 2.4,
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: getSm(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          last_detection
                              .add(snapshot.data['smoke'][0]['smoke']);
                          last_dec = last_detection[last_detection.length - 1];

                          // return Text("${snapshot.data['smoke'][0]['smoke']}");
                          // "${snapshot.data['temperature'][index]['temp']}");
                          return Column(
                            children: [
                              const Text("not detect"),
                              CircleAvatar(
                                backgroundColor:
                                    last_dec == 0 ? Colors.green : Colors.red,
                                radius: MediaQuery.of(context).size.height / 20,
                                child: last_dec == "not detect"
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
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: Consumer<Auth>(builder: (context, auth, child) {
          if (!auth.authenticated) {
            return ListView(
              children: [
                ListTile(
                  title: const Text('LOGIN'),
                  leading: const Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
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
