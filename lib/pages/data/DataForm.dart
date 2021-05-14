import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soccer/data/RestoreResult.dart';
import 'package:soccer/nav/NavDrawer.dart';
import 'package:soccer/pages/data/LoadResults.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class DataForm extends StatefulWidget {
  static const route = "/data";

  @override
  _DataFormState createState() => _DataFormState();
}

class _DataFormState extends State {
  final dataText = TextEditingController();
  String errorText = "";
  StorageService storage = locator<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Soccer: Data"),
        ),
        drawer: NavDrawer(),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                          onPressed: () async {
                            var json = await storage.backup();
                            setState(() {
                              errorText = "";
                              dataText.text = json;
                            });
                          },
                          child: Text("Backup")),
                    ),
                  ),
                  Expanded(child: Container(
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: dataText.text));
                      },
                      child: Text("Copy All"),
                    ),
                  )),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (dataText.text.isEmpty) {
                              setState(() {
                                errorText = "Enter data before loading";
                              });
                              return;
                            } else {
                              errorText = "";
                            }
                            RestoreResult result =
                                await storage.restore(dataText.text);
                            /* ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Loaded"))); */
                            Navigator.pushNamed(context, LoadResults.route,
                                arguments: result);
                          },
                          child: Text("Load")),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (dataText.text.isEmpty) {
                              setState(() {
                                errorText = "Enter data before loading";
                              });
                              return;
                            } else {
                              errorText = "";
                            }
                            RestoreResult result =
                            await storage.restoreUpdate(dataText.text);
                            /* ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Loaded"))); */
                            Navigator.pushNamed(context, LoadResults.route,
                                arguments: result);
                          },
                          child: Text("Load Update")),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              errorText = "";
                            });
                            print("Google signin");
                            storage.googleSignIn();
                          },
                          child: Text("Google Signin")),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Data",
                      errorText: errorText.isEmpty ? null : errorText),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: dataText,
                ),
              )
            ],
          ),
        ));
  }
}
