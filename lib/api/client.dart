import 'package:dio/dio.dart';
import 'package:youdownload/api/task.dart';
import '../config.dart';
import 'entites.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static Dio _dio = new Dio();

  factory ApiClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.baseUrl = ApplicationConfig().serviceUrl;
        String token = ApplicationConfig().token;
        if (token != null && token.isNotEmpty) {
          options.headers = {"Authorization": "Bearer $token"};
        }
        handler.next(options);
      },
    ));
    return _instance;
  }

  Future<ServiceInfo> fetchInfo() async {
    var response = await _dio.get("/info");
    return ServiceInfo.fromJson(response.data);
  }

  Future<List<Task>> fetchTask() async {
    var response = await _dio.get("/tasks");
    List<Task> tasks = [];
    response.data["list"]
        .forEach((rawTask) => tasks.add(Task.fromJson(rawTask)));
    return tasks;
  }

  Future<void> stopTask(String id) async {
    await _dio.post("/task/stop", queryParameters: {"id": id});
  }

  Future<void> startTask(String id) async {
    await _dio.post("/task/start", queryParameters: {"id": id});
  }

  Future<void> deleteTask(String id) async {
    await _dio.post("/task/delete", queryParameters: {"id": id});
  }

  Future<void> newMagnetTask(String link) async {
    await _dio.post("/task/magnet", data: {"link": link});
  }

  Future<void> newDownloadTask(String link) async {
    await _dio.post("/task/download/file", data: {"link": link});
  }

  ApiClient._internal();
}
