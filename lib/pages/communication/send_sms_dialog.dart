import 'package:flutter/material.dart';
import 'package:soccer/data/CommunicationItem.dart';

class SendSMSDialog extends Dialog {
  SendSMSDialog({required BuildContext context, required String communicationText, required List<CommunicationItem> addressList}) : super(
        child: Card(
          margin: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.blueAccent,
                child: Text("Confirm Sending SMS Messages",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text("This will send each player an individual SMS message with the below text.  After it is sent, you can view the message and any responses in your default SMS app.",
                style: TextStyle(fontStyle: FontStyle.italic),),
              ),
              ListTile(
                leading: const Icon(Icons.mail_outline),
                title: Text(communicationText),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text("Recipients",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: addressList.length,
                  itemBuilder: (context, index) {
                    var item = addressList[index];
                    var player = item.player;
                    var name = "";
                    if(player != null) {
                      name = " (${player.name})";
                    }
                    return ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text("${item.address}$name"),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(onPressed: () {
                      Navigator.pop(context, SendSMSDialogResult.sendText);
                    }, child: const Text("Cancel")),
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context, SendSMSDialogResult.sendText);
                    }, child: Text("Send"))
                  ],
                ),
              )
            ],
          ),
        )
  );

  static Future<SendSMSDialogResult?> showSMSDialog(
      {required BuildContext context, required String communicationText, required List<CommunicationItem> addressList}) async {
    return showDialog<SendSMSDialogResult>(
      context: context,
      builder: (BuildContext context) {
        return SendSMSDialog(
          context: context,
          communicationText: communicationText,
          addressList: addressList,
        );
      },
    );
  }
}

enum SendSMSDialogResult {
  sendText,
  cancel
}