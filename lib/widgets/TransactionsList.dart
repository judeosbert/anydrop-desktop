import 'dart:io';

import 'package:AnyDrop/helpers/CommandHelper.dart';
import 'package:AnyDrop/helpers/FileHelper.dart';
import 'package:AnyDrop/helpers/Utils.dart';
import 'package:AnyDrop/server/Server.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../DataTypes.dart';

class TransactionsList extends StatefulWidget {
  final Key key;
  final void Function (String) onLog;
  TransactionsList({this.key,@required this.onLog}) : super(key: key);

  @override
  TransactionsListState createState() => TransactionsListState();
}

class TransactionsListState extends State<TransactionsList> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    Server server = Server();
    server.transactionStream.listen((t) {
      debugPrint("New Transaction ${t.toString()}");
      switch (t.type) {
        case TransactionType.STRING:
          addStringTransaction(t);
          break;
        case TransactionType.FILE:
          addFileTransaction(t);
          break;
      }
    });
  }

  void addStringTransaction(StringTransaction t) {
    copyToClipboard(t.value);
    setState(() {
      transactions.insert(0, t);
    });
  }

  void addFileTransaction(FileTransaction t) {
    setState(() {
      transactions.insert(0, t);
    });
  }

  void copyToClipboard(String value){
    Utils.copyToClipboard(value).then((_){
      doSnackbar(context, "${value} copied to clipboard");
    }).catchError((onError){
      doSnackbar(context, "Error copying text to clipboard");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: _getListOrEmptyScreen());
  }

  Widget _getListOrEmptyScreen() {
    if (transactions.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.child_care,
            size: 200,
            color: Colors.grey[350],
          ),
          Text("You have not transferred anything yet !!")
        ],
      );
    } else {
      return ListView.separated(
        separatorBuilder: (_,__) => Divider(),
        itemBuilder: (context, index) {
          Transaction currentTransaction = transactions[index];
          bool isFileTransaction() => currentTransaction.type == TransactionType.FILE;

          return InkWell(
            onTap: () {
              if(isFileTransaction()){
                openFileViewer(currentTransaction);
              }else{
                copyToClipboard(currentTransaction.getTitle());
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: ListTile(
                leading: _getIconForTransaction(currentTransaction),
                title: Text(currentTransaction.getTitle()),
                subtitle: Text(timeago.format(currentTransaction.timestamp)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _getSpecificAction(currentTransaction),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          if (isFileTransaction()) {
                            FileTransaction t =
                                currentTransaction as FileTransaction;
                            FileHelper.deleteFile(t.file).then((doesExist) {
                              if (!doesExist) {
                                widget.onLog("Deleted ${currentTransaction.getTitle()}");
                                setState(() {
                                  transactions.removeAt(index);
                                });
                              }
                            }).catchError((_){
                              setState(() {
                                transactions.removeAt(index);
                              });
                            });
                          }
                          else{
                            setState(() {
                              transactions.removeAt(index);
                            });
                          }
                        })
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: transactions.length,
      );
    }
  }
  

  Icon _getIconForTransaction(Transaction t) {
    switch (t.type) {
      case TransactionType.STRING:
        return Icon(Icons.font_download);
        break;
      case TransactionType.FILE:
        return Icon(Icons.attach_file);
        break;
    }
    return Icon(Icons.device_unknown);
  }
  IconButton _getSpecificAction(Transaction t){
    switch(t.type){
      case TransactionType.STRING:
        StringTransaction stringTransaction = t as StringTransaction;
        return IconButton(icon: Icon(Icons.content_copy),
        onPressed: (){
          copyToClipboard(stringTransaction.value);
        },
        );
        break;
      case TransactionType.FILE:
        return IconButton(icon: Icon(Icons.open_in_browser),
          onPressed: (){
            openFileViewer(t);
          },
        );
        break;
        default:
          return IconButton(icon: Icon(Icons.device_unknown), onPressed: null);
    }

  }
  void openFileViewer(FileTransaction fileTransaction){
    CommandHelper.openFileManager(fileTransaction.file.path).then((output){
      doSnackbar(context, "File opened in viewer");
    }).catchError((error){
      debugPrint(error.toString());
      doSnackbar(context, "Error opening the file. Maybe the file doesn't exist.",type:SnackbarType.ERROR);
    });

  }
}
