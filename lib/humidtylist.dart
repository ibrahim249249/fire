import 'package:flutter/material.dart';

import 'crud.dart';
import 'linkapi.dart';
import 'main.dart';

class HumidtyList extends StatefulWidget {
  const HumidtyList({super.key});

  @override
  State<HumidtyList> createState() => _HumidtyListState();
}

class _HumidtyListState extends State<HumidtyList> with Crud {
  Future getHumidty() async {
    var response =
        await postRequest(linkHumidty, {"id": sharedPref.getString("id")});
    return response;
  }

  Stream getHum() => Stream.periodic(const Duration(seconds: 1))
      .asyncMap((event) => getHumidty());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' HUMIDITY'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              FutureBuilder(
                  future: getHumidty(),
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
                                      buildRow(['id', 'Humidity', 'DateTime'],
                                          isHeader: true),
                                      for (int i = 0;
                                          i < snapshot.data['humidty'].length;
                                          i++)
                                        buildRow([
                                          '${i}',
                                          '${snapshot.data['humidty'][i]['humidty']} ',
                                          '${snapshot.data['humidty'][i]['dateTime']} '
                                        ]),
                                      // buildRow(['Ahmed', 'usa', '20']),
                                      // buildRow(['Ali', 'us', '23']),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            // return Text(
                            //     " humidity : ${snapshot.data['humidty'][index]['humidty']}     dateTime : ${snapshot.data['humidty'][index]['dateTime']}");
                            //"${snapshot.data['humidty'][index]['humidty']}");
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
