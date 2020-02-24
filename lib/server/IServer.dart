import 'dart:async';
import 'dart:io';

import '../DataTypes.dart';

abstract class IServer{
  Future<bool> start();
  Future<bool> stop();

  void Function(Transaction t) onReceived;
  void Function(String log) onLog;
  StreamController<Transaction> _streamController;
  InternetAddress localAddress = InternetAddress.anyIPv4;
  int portNumber = 22562;

}