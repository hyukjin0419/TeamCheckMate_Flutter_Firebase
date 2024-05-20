import 'dart:async';
import 'package:flutter/material.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    // init();
  }
/*-------------------------------------변수--------------------------------------*/
  //로그인이 되었는지 안 되었는지
  final bool _loggedIn = false;
  // _private변수이기 대문에 getter 필요
  bool get loggedIn => _loggedIn;
  String? uid;
}
