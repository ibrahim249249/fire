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

  Stream getHum() =>
      Stream.periodic(const Duration(seconds: 1)).asyncMap((event) => getHumidty());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          StreamBuilder(
              stream: getHum(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data['humidty'].length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Text(
                            " temp : ${snapshot.data['humidty'][index]['humidty']}     dateTime : ${snapshot.data['humidty'][index]['dateTime']}");
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
