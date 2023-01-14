import 'package:flutter/material.dart';

import 'crud.dart';
import 'linkapi.dart';
import 'main.dart';

class TempLast extends StatefulWidget {
  const TempLast({super.key});

  @override
  State<TempLast> createState() => _TempLastState();
}

class _TempLastState extends State<TempLast> with Crud {
  getTemperautre() async {
    var response =
        await postRequest(linkTemp, {"id": sharedPref.getString("id")});
    // var body = jsonDecode(response.body);
    // var prise = int.parse(body['price'].toString());
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          FutureBuilder(
              future: getTemperautre(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data['temperature'].length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Text(
                            //" temp : ${snapshot.data['temperature'][index]['temp']}     dateTime : ${snapshot.data['temperature'][index]['dateTime']}");
                            "${snapshot.data['temperature'][index]['temp']}");
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
