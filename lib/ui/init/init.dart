import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youdownload/api/client.dart';
import 'package:youdownload/ui/home/home.dart';
import 'package:youdownload/util/login_history.dart';

import '../../config.dart';

class InitPage extends StatefulWidget {
  const InitPage() : super();

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  String inputUrl = "";
  String inputUsername = "";
  String inputPassword = "";
  String loginMode = "history";

  Future<bool> _init() async {
    await LoginHistoryManager().refreshHistory();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _onFinishClick() async {
      var uri = Uri.parse(inputUrl);
      if (!uri.hasScheme) {
        inputUrl = "http://" + inputUrl;
      }
      if (!uri.hasPort) {
        inputUrl += ":5700";
      }
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("apiUrl", inputUrl);
      await ApplicationConfig().loadConfig();
      var info = await ApiClient().fetchInfo();
      if (inputUsername.isEmpty && inputPassword.isEmpty) {
        // without login
        ApplicationConfig().token = "";
        ApplicationConfig().username = "public";
        LoginHistoryManager()
            .add(LoginHistory(apiUrl: inputUrl, username: "public", token: ""));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return;
      }
      // login with account
      Dio dio = new Dio();
      var response = await dio.post(info.authUrl, data: {
        "username": inputUsername,
        "password": inputPassword,
      });
      if (response.data["success"]) {
        ApplicationConfig().token = response.data["token"];
        ApplicationConfig().username = inputUsername;
        LoginHistoryManager().add(LoginHistory(
            apiUrl: inputUrl,
            username: inputUsername,
            token: response.data["token"]));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onFinishClick();
        },
        backgroundColor: Colors.indigo,
        child: Icon(Icons.chevron_right,color: Colors.white,),
      ),
      body: FutureBuilder(
          future: _init(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(),
                        child: Text(
                          "YouDownload",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 48,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 72),
                        child: Text(
                          "from ProjectXPolaris",
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  loginMode = "history";
                                });
                              },
                              child: Text(
                                "LoginHistory",
                                style: TextStyle(
                                    color: loginMode == "history"
                                        ? Colors.black
                                        : Colors.black38,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300),
                              )),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  loginMode = "new";
                                });
                              },
                              child: Text(
                                "New Login",
                                style: TextStyle(
                                  color: loginMode == "new"
                                      ? Colors.black
                                      : Colors.black38,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                ),
                              ))
                        ],
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                        ),
                        child: loginMode == "new"
                            ? ListView(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Service URL'),
                                    onChanged: (text) {
                                      setState(() {
                                        inputUrl = text;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: TextField(
                                      decoration:
                                          InputDecoration(hintText: 'Username'),
                                      onChanged: (text) {
                                        setState(() {
                                          inputUsername = text;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: TextField(
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      obscureText: true,
                                      decoration:
                                          InputDecoration(hintText: 'Password'),
                                      onChanged: (text) {
                                        setState(() {
                                          inputPassword = text;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : ListView(
                                children:
                                    LoginHistoryManager().list.map((history) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      onTap: () {
                                        var config = ApplicationConfig();
                                        config.token = history.token;
                                        config.serviceUrl = history.apiUrl;
                                        config.username = history.username;
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()));
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.indigo,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(history.username),
                                      subtitle: Text(history.apiUrl),
                                    ),
                                  );
                                }).toList(),
                              ),
                      )),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }),
    );
  }
}
