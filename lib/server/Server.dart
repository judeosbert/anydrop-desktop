import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/FileHelper.dart';

import '../DataTypes.dart';

class Server {
  static Server _instance = Server._internal();

  factory Server() {
    return _instance;
  }

  Angel _app;
  AngelHttp _http;
  void Function(Transaction t) onReceived;
  void Function(String log) onLog;
  InternetAddress _localAddress = InternetAddress.anyIPv4;
  int _portNumber = 22562;
  StreamController<Transaction> _streamController;

  Server._internal() {
    _initializeStreamController();
  }

  void _initializeStreamController() {
    _streamController = StreamController<Transaction>.broadcast();
    debugPrint("Stream Controller Created");
  }

  Stream<Transaction> get transactionStream => _streamController.stream;

  Future<bool> start() async {
    _app = Angel();
    _http = AngelHttp(_app);
    _app.get("/ping", _pingHandler);
    _app.post("/string", _stringMessageHandler);
    _app.post("/file", _uploadHandler);

    onLog("Starting server");
    try {
      await _http.startServer(_localAddress.address, _portNumber);
      return Future.value(true);
    } on Exception catch (e) {
      onLog(e.toString());
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> stop() async {
    bool isServerRunning = true;
    try {
      await _http.close();
      isServerRunning = false;
      onLog("Server Stopped");
    } on Exception catch (e) {
      debugPrint(e.toString());
      onLog(e.toString());
    }

    return Future.value(isServerRunning);
  }

  //Handler Functions

  void _pingHandler(RequestContext req, ResponseContext res) async {
    Map<String, dynamic> response = await PingResponse.toJson();
    res.write(json.encode(response));
    res.close();
  }

  void _stringMessageHandler(RequestContext req, ResponseContext res) async {
    try {
      onLog("String message incoming");
      await req.parseBody();
      var reqBody = StringBody.fromJson(req.bodyAsMap);
      if (reqBody.value.isNotEmpty) {
        onLog("Received new string ${reqBody.value}");
        _streamController.sink.add(StringTransaction(value: reqBody.value));
        res.statusCode = 200;
        res.write("success");
      } else {
        res.statusCode = 400;
        res.write("Form Value is empty");
      }
    } catch (on, e) {
      print(e);
      res.statusCode = 400;
      res.write("Invalid Request Structure");
    }
    res.close();
  }

  void _uploadHandler(RequestContext req, ResponseContext res) async {
    onLog("File Upload Incoming");
    await req.parseBody();
    req.uploadedFiles.forEach((file) async {
      var result = await FileHelper.saveFile(file);
      debugPrint(result.toString());
      if (result.isSuccess) {
        FileTransaction t = FileTransaction(file: result.file);
        _streamController.sink.add(t);
        onLog("File Saved to ${result.file.path}");
        res.statusCode = 200;
        res.write("File upload success");
      } else {
        res.statusCode = 500;
        onLog("Error ${result.e.toString()}");
        res.write("Error ${result.e.toString()}");
      }
      res.close();
    });
  }
}
