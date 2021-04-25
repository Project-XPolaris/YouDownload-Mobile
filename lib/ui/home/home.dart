import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youdownload/api/client.dart';
import 'package:youdownload/components/new-download-dialog.dart';
import 'package:youdownload/components/new-magnet-dialog.dart';
import 'package:youdownload/components/task-info.dart';
import 'package:youdownload/components/task-item.dart';
import 'package:youdownload/ui/home/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
        create: (_) => HomeProvider(),
        child: Consumer<HomeProvider>(builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: Color(0xFFEEEEEE),
            appBar: AppBar(
              title: Text("YouDownload"),
              actions: [
                PopupMenuButton(
                  onSelected: (value) async {
                    if (value == "new_magnet") {
                      showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return NewMagnetDialog(
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                              onCreate: (link) {
                                ApiClient().newMagnetTask(link);
                                Navigator.of(context).pop();
                              },
                            );
                          });
                    }
                    if (value == "new_file") {
                      showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return NewDownloadDialog(
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                              onCreate: (link) {
                                ApiClient().newDownloadTask(link);
                                Navigator.of(context).pop();
                              },
                            );
                          });
                    }
                    if (value == "new_torrent_file") {
                      FilePickerResult result = await FilePicker.platform.pickFiles();
                      if (result.files.single != null) {
                        await ApiClient().newTorrentFileTask(result.files.single.path);
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: "new_magnet",
                      child: Text('Task from magnet link'),
                    ),
                    PopupMenuItem<String>(
                      value: "new_torrent_file",
                      child: Text('Task from torrent file'),
                    ),
                    PopupMenuItem<String>(
                      value: "new_file",
                      child: Text('Task from download link'),
                    )
                  ],
                  icon: Icon(Icons.more_vert),
                )
              ],
            ),
            body: IndexedStack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    provider.refreshData();
                  },
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      ...provider.tasks.map((task) {
                        return TaskItem(
                          task,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (sheetContext) {
                                  return TaskInfo(
                                    task,
                                    onDelete: () {
                                      Navigator.of(sheetContext).pop();
                                      AlertDialog alert = AlertDialog(
                                        title: Text("Remove confirm"),
                                        content:
                                            Text("Remove task ${task.name}"),
                                        actions: [
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              task.deleteTask();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );

                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    },
                                    onPause: () {
                                      task.stopTask();
                                      Navigator.of(context).pop();
                                    },
                                    onStart: () {
                                      task.startTask();
                                      Navigator.of(context).pop();
                                    },
                                  );
                                });
                          },
                        );
                      }),
                    ],
                  ),
                )
              ],
            ),
          );
        }));
  }
}
