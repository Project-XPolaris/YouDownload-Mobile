
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youdownload/api/client.dart';
import 'package:youdownload/api/task.dart';

class HomeProvider extends ChangeNotifier{
  List<Task> tasks = [];

  HomeProvider(){
    Timer.periodic(new Duration(seconds: 1), (timer) {
      refreshData();
    });
  }

  Future<void> refreshData() async {
    var response = await ApiClient().fetchTask();
    tasks = response;
    notifyListeners();
  }
}