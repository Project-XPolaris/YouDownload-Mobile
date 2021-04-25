import 'package:youdownload/api/client.dart';
import 'package:duration/duration.dart';

class Task {
  static String taskStatusEstimate = "Estimate";
  static String taskStatusDownloading = "Downloading";
  static String taskStatusStop = "Stop";
  static String taskStatusComplete = "Complete";
  String id;
  String name;
  int complete;
  int length;
  double progress;
  String status;
  int speed;
  int eta;
  Null extra;
  String type;
  String createTime;

  Task(
      {this.id,
      this.name,
      this.complete,
      this.length,
      this.progress,
      this.status,
      this.speed,
      this.eta,
      this.extra,
      this.type,
      this.createTime});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    complete = json['complete'];
    length = json['length'];
    progress = json['progress'].toDouble();
    status = json['status'];
    speed = json['speed'];
    eta = json['eta'];
    extra = json['extra'];
    type = json['type'];
    createTime = json['CreateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['complete'] = this.complete;
    data['length'] = this.length;
    data['progress'] = this.progress;
    data['status'] = this.status;
    data['speed'] = this.speed;
    data['eta'] = this.eta;
    data['extra'] = this.extra;
    data['type'] = this.type;
    data['CreateTime'] = this.createTime;
    return data;
  }

  stopTask() async {
    await ApiClient().stopTask(id);
  }

  startTask() async {
    await ApiClient().startTask(id);
  }

  deleteTask() async {
    await ApiClient().deleteTask(id);
  }

  getETAText() {
    Duration dur = Duration(seconds: eta);
    return printDuration(dur);
  }
}
