import 'package:baselib/ext/ext.dart';

class NetPageData<T> {
  late int currPage;
  late List<T>? list;
  late int pageSize;
  late int totalCount;
  late int totalPage;

  NetPageData({this.currPage = 1, this.list = const [], this.pageSize = 0, this.totalCount = 0, this.totalPage = 0});

  factory NetPageData.fromJson(Map<String, dynamic> json, T Function(dynamic data) decoder) {
    return NetPageData(
        currPage: asT<int>(json['currPage'], 1)!,
        list: (json['list'] is List) ? (json['list'] as List).map((e) => decoder(e)).toList() : const [],
        pageSize: asT<int>(json['pageSize'])!,
        totalCount: asT<int>(json['totalCount'])!,
        totalPage: asT<int>(json['totalPage'])!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currPage'] = this.currPage;
    data['list'] = this.list;
    data['pageSize'] = this.pageSize;
    data['totalCount'] = this.totalCount;
    data['totalPage'] = this.totalPage;
    return data;
  }
}
