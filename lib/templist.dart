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
      appBar: AppBar(
        title: const Text(' TEMPERATURE'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              FutureBuilder(
                  future: getTemperautre(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: 1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
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
                                      for (int i = 0;
                                          i <
                                              snapshot
                                                  .data['temperature'].length;
                                          i++)
                                        buildRow([
                                          '${i}',
                                          '${snapshot.data['temperature'][i]['temp']} ',
                                          '${snapshot.data['temperature'][i]['dateTime']} '
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
                            // return Text(
                            //     " temp : ${snapshot.data['temperature'][index]['temp']}     dateTime : ${snapshot.data['temperature'][index]['dateTime']}");
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
        ),
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
