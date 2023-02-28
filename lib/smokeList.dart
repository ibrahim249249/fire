import 'package:flutter/material.dart';

import 'crud.dart';
import 'linkapi.dart';
import 'main.dart';

class SmokeList extends StatefulWidget {
  const SmokeList({super.key});

  @override
  State<SmokeList> createState() => _SmokeListState();
}

class _SmokeListState extends State<SmokeList> with Crud {
  final Crud _crud = Crud();
  Future getSmoke() async {
    var response =
        await _crud.postRequest(linkSmoke, {"id": sharedPref.getString("id")});
    // var responsebody = jsonDecode(response.body);
    return response;
  }

  Stream getSm() => Stream.periodic(const Duration(seconds: 1))
      .asyncMap((event) => getSmoke());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' SMOKE'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              FutureBuilder(
                  future: getSmoke(),
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
                                      buildRow(['id', 'Smoke', 'DateTime'],
                                          isHeader: true),
                                      for (int i = 0;
                                          i < snapshot.data['smoke'].length;
                                          i++)
                                        buildRow([
                                          '${i}',
                                          snapshot.data['smoke'][i]['smoke'] ==
                                                  1
                                              ? 'detected'
                                              : 'not detected',
                                          '${snapshot.data['smoke'][i]['dateTime']} '
                                        ]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            // return Center(
                            //   child: Text(snapshot.data['smoke'][index]['smoke'] ==
                            //           0
                            //       ? "  Not Detected   dateTime : ${snapshot.data['smoke'][index]['dateTime']}"
                            //       : "  Detected         dateTime : ${snapshot.data['smoke'][index]['dateTime']}  "),
                            // );
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
