import 'package:flutter/material.dart';
// Breaks DateTime for some reason
// import 'package:googleapis/content/v2_1.dart';
import 'package:soccer/data/Practice.dart';
import 'package:soccer/nav/args/EventArgs.dart';
import 'package:soccer/pages/main/PracticeMain.dart';
import 'package:soccer/pages/util/DateField.dart';
import 'package:soccer/pages/util/TimeField.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class PracticeSetup extends StatefulWidget {
  static const route = "/setup/practice";
  @override
  _PracticeSetupState createState() => _PracticeSetupState();
}

class _PracticeSetupState extends State<PracticeSetup> {
  StorageService storage = locator<StorageService>();
  DateEditingController practiceDateController = DateEditingController();
  TimeEditingController practiceTimeController = TimeEditingController();

  @override
  Widget build(BuildContext context) {
    final EventArgs args = ModalRoute.of(context)!.settings.arguments as EventArgs;
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Soccer: Practice"),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                Navigator.pushNamed(context, PracticeMain.route,
                    arguments: args);
              },
                itemBuilder: (context) {
              return [const PopupMenuItem(value: "go", child: Text("Go"))];
            })
          ],
        ),
        body: FutureBuilder<Practice>(
            future: getPractice(args.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Practice practice = snapshot.data!;
                if(practice.eventDate == null) {
                  practice.eventDate = DateTime.now();
                }
                practiceDateController.value = practice.eventDate;
                print("practice event date: ${practice.eventDate} -- id: ${practice.id}");
                practiceTimeController.value = TimeOfDay.fromDateTime(practice.eventDate);
                return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              DateField(
                                labelText: "Date of Practice",
                                controller: practiceDateController,
                                validator: (newValue) {
                                  if(newValue == null) {
                                    return "Practice date is required";
                                  }
                                },
                              ),
                              TimeField(
                                labelText: "Time of Practice",
                                controller: practiceTimeController,
                                validator: (newValue) {
                                  if(newValue == null) {
                                    return "Practice time is required";
                                  }
                                },
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: ElevatedButton(
                                    child: Text("Save"),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        DateTime date = practiceDateController.value ?? DateTime.now();
                                        TimeOfDay? time = practiceTimeController.value;
                                        if(time == null) {
                                          time = TimeOfDay.fromDateTime(DateTime.now());
                                        }
                                        practice.eventDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("Saving...")));
                                        bool isNew = false;
                                        if (practice.id <= 0) {
                                          isNew = true;
                                        }
                                        await storage.savePractice(practice);
                                        if (isNew) {
                                          print("adding to team ${practice.id}");
                                          args.team.addPractice(practice);
                                          await storage.saveTeam(args.team);
                                        }
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                SnackBar(content: Text("Saved")));
                                      }
                                    },
                                  ))
                            ],
                          )),
                    ));
              } else {
                return CircularProgressIndicator();
              }
            }),
    );
  }

  Future<Practice> getPractice(int id) async {
    if (id <= 0) {
      return Practice(eventDate: DateTime.now());
    }
    return await storage.getPractice(id);
  }
}
