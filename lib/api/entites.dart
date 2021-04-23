class ServiceInfo {
  String authUrl;
  String name;
  ServiceInfo.fromJson(Map<String, dynamic> json) {
    authUrl = json['authUrl'];
    name = json['name'];
  }
}
class ListResponseWrap<T> {
  int count;
  List<T> data;

  ListResponseWrap({this.count, this.data});

  ListResponseWrap.fromJson(Map<String, dynamic> json,Function(dynamic) converter) {
    count = json['count'];
    if (json['data'] != null) {
      data = new List<T>();
      json['data'].forEach((v) {
        data.add(converter(v));
      });
    }
  }
}