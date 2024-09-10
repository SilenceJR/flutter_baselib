import 'package:flutter_baselib/base/base_cl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

mixin RefreshMixin on BaseGetController {
  late final RefreshController refreshController;

  int pageNum = 1;

  bool get initialRefresh => false;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: initialRefresh);
  }

  void refreshPage() {
    pageNum = 1;
    refreshController.resetNoData();
    _loadPage();
  }

  void _loadPage() async {
    try {
      final (ok, noData) = await loadData();
      _refreshDone(ok, hasNext: noData ?? true);
    } on Exception catch (e) {
      _refreshDone(false);
      rethrow;
    }
  }

  Future<(bool, bool?)> loadData();

  void _refreshDone(bool ok, {bool hasNext = true}) {
    if (refreshController.isRefresh) {
      ok
          ? refreshController.refreshCompleted()
          : refreshController.refreshFailed();
    }
    if (refreshController.isLoading) {
      ok ? refreshController.loadComplete() : refreshController.loadFailed();
    }
    if (hasNext == false) {
      refreshController.loadNoData();
    }
    if (ok) pageNum++;
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
