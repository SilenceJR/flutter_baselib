import 'package:pull_to_refresh/pull_to_refresh.dart';

extension RefreshStateExt on RefreshController {
  finishState(bool complete, [bool noData=false]) {
    if (isRefresh) {
      complete ? refreshCompleted() : refreshFailed();
    }
    if (isLoading) {
      complete ? loadComplete() : loadFailed();
    }
    noData ? loadNoData() : resetNoData();
  }
}
