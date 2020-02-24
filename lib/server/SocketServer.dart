import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:AnyDrop/server/IServer.dart';
import 'package:flutter/cupertino.dart';

import '../DataTypes.dart';

class SocketServer extends IServer{
  void Function(Transaction t) onReceived;
  void Function(String log) onLog;
  static SocketServer _instance = SocketServer._internal();
  factory SocketServer() => _instance;
  StreamController<Transaction> _streamController;
  StreamController<Map<String,dynamic>> _incomingMessageStream;
  bool _isServerConnected = false;


  String _activeTransactionString;
  File _activeTransactionFile;


  SocketServer._internal();

  ServerSocket _serverSocket;
  Socket _clientSocket;


  void _createMessageStream(){
    _incomingMessageStream = StreamController<Map<String,dynamic>>.broadcast();
    _incomingMessageStream.stream.listen(_onData);
  }

  void _onData( Map<String,dynamic> data ){
    debugPrint("Data In MessageStream");
    debugPrint(data.toString()+"\n");
    switch(data["type"]){
      case "file":
        _handleFileTransfer(_clientSocket,data);
        break;
      case "string":
        _handleStringTransfer(_clientSocket,data);
        break;
      case "ping":
        _handlePingMessage(_clientSocket,data);
        break;

    }

  }



  @override
  Future<bool> start() async {
    try {
      _serverSocket = await ServerSocket.bind(localAddress, portNumber);
      _serverSocket.listen(_handleConnection,onError: (err){
        debugPrint("Socket Closed ${err.toString()}");
      });
//      onLog("Server Started");
      return Future.value(true);
    }
    catch(e){
      onLog(e.toString());
      debugPrint(e);
      return Future.value(false);
    }
  }

  void _handleConnection(Socket socket){
    if(_isServerConnected){
      socket.close();
      return;
    }
    debugPrint("Incoming connection from ${socket.remoteAddress.toString()}");
    _createMessageStream();
    _isServerConnected = true;
    _clientSocket = socket;
    socket.listen((data) {
      socket.write("Data Incoming");
      socket.flush();
      var jsonData = json.decode(String.fromCharCodes(data).trim());
//      debugPrint(jsonData.toString());
      _incomingMessageStream.add(jsonData);
    });
  }


  @override
  Future<bool> stop() {
    throw UnimplementedError();
  }

  void _handleFileTransfer(Socket socket,Map<String,dynamic> jsonData) {


  }

  void _handleStringTransfer(Socket socket,Map<String,dynamic> jsonData) {
    if(_activeTransactionString == null){
      _activeTransactionString = "";
    }
    void _concatData(){
      List<int> byteArray = List<int>.from(jsonData["data"]);
      _activeTransactionString+=utf8.decode(byteArray);
    }

    void _sendTransaction(){
      print(_activeTransactionString);
      StringTransaction transaction = StringTransaction(value: _activeTransactionString);
      _streamController.add(transaction);
    }
    if(isLastPacket(jsonData)) {
      _concatData();
      _sendTransaction();
      _resetFlags();
      return;
    }
    _concatData();

  }

  void _resetFlags(){
    _activeTransactionString = null;
    _activeTransactionFile = null;
  }

  void _handlePingMessage(Socket socket,Map<String,dynamic> jsonData) async{
    try {
      debugPrint("Handling Ping Message");
      String response = await PingResponse.toJson();
      debugPrint("Ping Response $response");
      socket.write(response);
      socket.flush();
      debugPrint("Ping Response Sent");
    }catch(e){
      debugPrint(e.toString());
    }
  }

  bool isLastPacket(Map<String, dynamic> jsonData) =>
    jsonData["currentPacketNumber"] == jsonData["totalNumberOfPackets"] - 1;


}

