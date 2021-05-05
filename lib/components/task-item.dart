import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:youdownload/api/task.dart';

class TaskItem extends StatelessWidget {
  final Function onTap;
  final Task task;

  TaskItem(this.task, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      child: Icon(Icons.file_download),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            Text(
                              "${task.type} - ${task.status}",
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.speed),
                                margin: EdgeInsets.only(right: 8),
                              ),
                              Expanded(child: Text("${filesize(task.speed)}/s"))
                            ],
                          )),
                      Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.data_usage),
                                margin: EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                  child: Text(
                                      "${filesize(task.complete)}/${filesize(task.length)}"))
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                    child: Text(task.getETAText())
                ),
                Container(
                  margin: EdgeInsets.only(),
                  child: Row(
                    children: [
                      Expanded(
                          child: LinearProgressIndicator(
                        backgroundColor: Color(0xFFC5CAE9),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                        value: task.progress,
                      )),
                      Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Text("${(task.progress * 100).ceil()}%"))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
