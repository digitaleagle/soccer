import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soccer/data/RestoreResult.dart';
import 'package:soccer/nav/NavDrawer.dart';
import 'package:soccer/pages/data/LoadResults.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class DataForm extends StatefulWidget {
  static const route = "/data";

  const DataForm({Key? key}) : super(key: key);

  @override
  _DataFormState createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> {
  final dataText = TextEditingController();
  String errorText = "";
  StorageService storage = locator<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Soccer: Data"),
        ),
        drawer: NavDrawer(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                          onPressed: () async {
                            var json = await storage.backup();
                            setState(() {
                              errorText = "";
                              dataText.text = json;
                            });
                          },
                          child: const Text("Backup")),
                    ),
                  ),
                  Expanded(child: Container(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: dataText.text));
                      },
                      child: const Text("Copy All"),
                    ),
                  )),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
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
                          child: const Text("Load")),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
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
                          child: const Text("Load Update")),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              errorText = "";
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Signing into Google Account")));
                            print("Google signin");
                            try {
                              await storage.googleSignIn();

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Sign in complete")));
                            } catch (e, trace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Failed to sign in")));
                              print("Google Signin Failed: \n ${e.toString()} \n\n$trace");
                              setState(() {
                                dataText.text = "${e.toString()}\n\n$trace";
                                errorText = e.toString();
                              });
                            }
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
