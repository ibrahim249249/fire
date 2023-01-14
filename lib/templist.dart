// ignore_for_file: unused_local_variable

import 'package:fire_app/main.dart';
import 'package:flutter/material.dart';

import 'crud.dart';
import 'linkapi.dart';

class TempList extends StatefulWidget {
  @override
  State<TempList> createState() => _TempListState();
}

class _TempListState extends State<TempList> with Crud {
  // Crud _crud = Crud();

  @override
  Future getTemperautre() async {
    var response =
        await postRequest(linkTemp, {"id": sharedPref.getString("id")});
    return response;
  }

  Stream getTempe() => Stream.periodic(const Duration(seconds: 1))
      .asyncMap((event) => getTemperautre());

  //final Future temps;
  // templist() async {
  //   var response = await _crud.getTemp(linkTemp);
  //   // if (response['status'] == "success") {
  //   //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => TempList()));
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    // var temps = [34, 55, 33, 34, 40];
    //Future<List> temps = getTemperautre();

    //var lastItem  = await temps.length - 1;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          StreamBuilder(
              stream: getTempe(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data['temperature'].length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Text(
                            " temp : ${snapshot.data['temperature'][index]['temp']}     dateTime : ${snapshot.data['temperature'][index]['dateTime']}");
                        //"${snapshot.data['temperature'][index]['temp']}");
                      });
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text("loding...."),
                  );
                }
                return const Center(
                  child: Text("loding...."),
                );
              }),
        ],
      ),
      // body: ListView.builder(
      //   itemBuilder: (context, i) {
      //     return Column(
      //       children: [Text('${temps}')],
      //     );
      //   },
      //   //itemCount: templist(),
      // ),
    );
  }
}
