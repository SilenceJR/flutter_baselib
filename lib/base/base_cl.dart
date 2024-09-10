import 'package:flutter/material.dart';
import 'package:flutter_baselib/mixin/refresh_mixin.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' show CancelToken;
export 'package:get/get.dart';

enum PageStatus {
  idle,
  loading,
  success,
  error,
  empty,
}

mixin BaseGetControllerMixin implements DisposableInterface {
  final List<Worker> _workers = [];
  final pageStatus = PageStatus.idle.obs;

  void registerWorker(Worker worker) {
    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }
  }

  void unRegisterWorker(Worker worker) {
    if (_workers.contains(worker)) {
      _workers.remove(worker);
    }
    worker.dispose();
  }

  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    _workers.clear();
  }
}

abstract class BaseGetController extends GetxController
    with BaseGetControllerMixin {
  final cancelToken = CancelToken();

  @override
  void onClose() {
    super.onClose();
    cancelToken.cancel();
  }
}

abstract class BaseGetRefreshController extends BaseGetController
    with RefreshMixin {}

abstract class BaseGetFullLifeCycleController extends FullLifeCycleController
    with BaseGetControllerMixin, FullLifeCycleMixin {}

abstract class BaseGetService extends GetxService with BaseGetControllerMixin {}

abstract class BaseGetFullService extends GetxService
    with WidgetsBindingObserver {
  void onResumed();

  void onInactive();

  void onPaused();

  void onDetached();

  void onHidden();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }
}
