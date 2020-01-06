import 'package:AnyDrop/widgets/LogScreen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:AnyDrop/server/Server.dart';
import 'package:AnyDrop/widgets/ConnectionParameterWidget.dart';
import 'package:AnyDrop/widgets/ConnectionStatusBar.dart';
import 'package:AnyDrop/widgets/TransactionsList.dart';
import 'package:package_info/package_info.dart';

import '../DataTypes.dart';

class HomePage extends StatefulWidget {
  static final String routeName = "/";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController portNumberController;
  Server server;
  bool isServerRunning = false;
  List<Log> _logs = [];

  @override
  void initState() {
    super.initState();
    portNumberController = TextEditingController(text: "8080");
    server = Server();
    server.onLog = onLog;
    server.onReceived = onReceived;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
            onPressed: () async {
              showAboutDialog(
                context: context,
                applicationVersion: "1.0",
                applicationLegalese:
                    "Thank you for using AnyDrop. This was my side project using Flutter for Desktop.  This came out of my need to transfer files and lots of text at my work. If you like it, consider buying me a coffee 🤗",
                applicationName: "AnyDrop - Desktop",
              );
            },
            child: Icon(Icons.info_outline)),
        centerTitle: true,
        title: Text("AnyDrop - Desktop"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: !isServerRunning ? Colors.green : Colors.grey,
              ),
              onPressed: !isServerRunning
                  ? () {
                      server
                          .start(
                              portNumber: int.parse(portNumberController.text))
                          .then((isAlive) {
                        if (isAlive) {
                          setState(() {
                            isServerRunning = true;
                          });
                          doSnackbar(context, "Server is now running");
                        } else {
                          doSnackbar(context,
                              "Server Could not Start.Please change port number and try again");
                        }
                      });
                    }
                  : null),
          IconButton(
              icon: Icon(
                Icons.stop,
                color: isServerRunning ? Colors.red : Colors.grey,
              ),
              onPressed: isServerRunning
                  ? () {
                      server.stop().then((isAlive) {
                        if (!isAlive) {
                          setState(() {
                            isServerRunning = false;
                          });
                          doSnackbar(context, "Server has been stopped");
                        } else {
                          doSnackbar(context,
                              "Could not stop the server. Please try again or close the app.");
                        }
                      });
                    }
                  : null),
          Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.code),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                }),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: ConnectionParameterWidget(portNumberController),
              ),
              ConnectionStatusBar(isServerRunning),
              Container(
                margin: EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  "History",
                  style: Theme.of(context).textTheme.headline.merge(
                        TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.display2.fontSize),
                      ),
                ),
              ),
              TransactionsList(
                onLog: onLog,
              ),
            ],
          ),
        ],
      ),
      endDrawer: Drawer(child: LogScreen(_logs)),
    );
  }

  void onReceived(Transaction t) {}

  void onLog(String log) {
    setState(() {
      _logs.insert(0, Log(log));
    });
  }

  void doSnackbar(BuildContext context, String message,
      {SnackbarType type = SnackbarType.INFO}) {
    bool isTypeNotification() => type == SnackbarType.INFO;
    Flushbar(
      title: isTypeNotification() ? "Heads up" : "Oops",
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.symmetric(horizontal: 10),
      leftBarIndicatorColor: isTypeNotification() ? Colors.blue : Colors.red,
      icon: isTypeNotification()
          ? Icon(
              Icons.info,
              color: Colors.blue,
            )
          : Icon(
              Icons.error,
              color: Colors.red,
            ),
      duration: Duration(seconds: 2),
    )..show(context);
  }
}
