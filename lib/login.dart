// ignore_for_file: prefer_const_constructors, implementation_imports, unnecessary_import, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, avoid_print, unused_local_variable, override_on_non_overriding_member, prefer_typing_uninitialized_variables

import 'package:fire_app/crud.dart';
import 'package:fire_app/linkapi.dart';
import 'package:fire_app/main.dart';
import 'package:fire_app/main_minu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// ignore: unused_import

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //const LoginPage({super.key});
  final GlobalKey<FormState> _LoginformKey = GlobalKey();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  Crud crud = Crud();
  bool isLoading = false;

  login() async {
    if (_LoginformKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await crud.postRequest(linkLogin, {
        "email": usernameController.text,
        "password": passwordController.text,
      });
      isLoading = false;
      setState(() {});
      if (response["status"] == "success") {
        sharedPref.setString("id", response['data']['id'].toString());
        sharedPref.setString(
            "username", response['data']['username'].toString());
        sharedPref.setString("email", response['data']['email'].toString());

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MainMenu()));
        //                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));

      } else {
        AwesomeDialog(
            context: context,
            btnCancel: Text("Cancel"),
            title: "worning",
            body: Text(
                "the email or the password is wrong or the acount is not exist"))
          .show();
      }
    }
  }

  @override
  void initState() {
    // usernameController.text='ibrahim@test.com';
    // passwordController.text='password';
    super.initState();
    // creatDatabase();
  }

  @override
  // void dispose() {
  //   usernameController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/Security-Alarm-System (1).jpg'),
                  fit: BoxFit.cover),
            ),
            child: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Center(
                                child: FlutterLogo(
                                  size: 100,
                                ),
                              ),
                              Form(
                                key: _LoginformKey,
                                child: Padding(
                                    padding:
                                        EdgeInsets.all(15), //white space around
                                    child: Column(
                                      children: [
                                        /////////////////////////////////////////
                                        ///
                                        ///
                                        ///hh
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: TextFormField(
                                              controller: usernameController,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  labelText: 'email',
                                                  hintText:
                                                      'Enter valid username '),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 15,
                                              bottom: 0),
                                          child: TextFormField(
                                            controller: passwordController,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                labelText: 'Password',
                                                hintText:
                                                    'Enter secure password'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter some text';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        MaterialButton(
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 20),
                                          onPressed: () async {
                                            await login();
                                          },
                                          child: Text("LOGIN"),
                                        ),
                                        // SizedBox(
                                        //   //sized box to control elevation button size
                                        //   height: 50,
                                        //   width: 200,
                                        //   child: ElevatedButton(
                                        //     style: ButtonStyle(
                                        //       backgroundColor:
                                        //           MaterialStateProperty.all<Color>(
                                        //               Colors.purple),
                                        //     ),
                                        //     child: Text('Login'),
                                        //     onPressed: () {
                                        //       Map creds = {
                                        //         'email' : usernameController.text,
                                        //         'password' : passwordController.text,
                                        //         'device_naem' : 'Mobile',
                                        //       };
                                        //       if (_LoginformKey.currentState!.validate()) {
                                        //         Provider.of<Auth>(context,listen: false).Login(creds);
                                        //         Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //               builder: (context) =>MainMenu(),
                                        //           ),
                                        //         );
                                        //       }
                                        //     },
                                        //   ),
                                        // ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))));
  }
}
