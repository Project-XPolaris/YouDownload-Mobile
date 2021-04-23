import 'package:flutter/material.dart';
import 'package:youdownload/api/task.dart';

class TaskInfo extends StatelessWidget {
  final Function onDelete;
  final Function onStart;
  final Function onPause;
  final Task task;

  TaskInfo(this.task, {this.onDelete, this.onStart, this.onPause});

  @override
  Widget build(BuildContext context) {
    List<Widget> renderActions() {
      List<Widget> actions = [];
      if (task.status == Task.taskStatusEstimate ||
          task.status == Task.taskStatusDownloading ||
          task.status == Task.taskStatusStop ||
          task.status == Task.taskStatusComplete) {
        actions.add(Container(
          margin: EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              if (onDelete != null) {
                onDelete();
              }
            },
            icon: Icon(Icons.delete),
          ),
        ));
      }
      if (task.status == Task.taskStatusStop) {
        actions.add(Container(
          margin: EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              if (onStart != null) {
                onStart();
              }
            },
            icon: Icon(Icons.play_arrow),
          ),
        ));
      }
      if (task.status == Task.taskStatusDownloading) {
        actions.add(Container(
          margin: EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              if (onPause != null) {
                onPause();
              }
            },
            icon: Icon(Icons.pause),
          ),
        ));
      }

      return actions;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Icon(Icons.file_download),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child: Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.name,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
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
              ),
              ...renderActions()
            ],
          ),
        ],
      ),
    );
  }
}
