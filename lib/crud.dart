// import 'dart:html';

// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode} ");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }

  getTemp(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print(" Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }

  //
  postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode} ");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }
}
