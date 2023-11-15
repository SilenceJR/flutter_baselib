import 'package:flutter/material.dart';
import 'package:flutter_baselib/baselib.dart';

extension Alert on GetInterface {
  Future<T?> showDialog<T>(Widget widget,
      {bool barrierDismissible = true,
      Color barrierColor = Colors.black38,
      bool useSafeArea = true,
      Object? arguments,
      Duration? transitionDuration,
      Curve? transitionCurve,
      String? name,
      RouteSettings? routeSettings,
      bool hideKeyboard = true}) {
    if (hideKeyboard) {
      hideKeyBoard();
    }
    return Get.dialog(widget,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        useSafeArea: useSafeArea,
        arguments: arguments,
        transitionDuration: transitionDuration,
        transitionCurve: transitionCurve,
        name: name,
        routeSettings: routeSettings);
  }

  Future<T?> showTopSheet<T>(
    Widget topSheet, {
    Color barrierColor = Colors.black38,
    bool hideKeyboard = true,
    bool barrierDismissible = true,
    bool useRootNavigator = false,
    bool? ignoreSafeArea,
    bool isScrollControlled = false,
    RouteSettings? routeSettings,
    EdgeInsetsGeometry? offset,
  }) {
    if (hideKeyboard) {
      hideKeyBoard();
    }
    return Navigator.of(overlayContext!, rootNavigator: useRootNavigator).push<T>(TopSheetRoute<T>(
        builder: (_) => topSheet,
        isScrollControlled: isScrollControlled,
        ignoreSafeArea: ignoreSafeArea,
        barrierColor: barrierColor,
        offset: offset,
        settings: routeSettings));
  }

  Future<T?> showBottomSheet<T>(Widget bottomSheet,
      {Color? backgroundColor,
      double? elevation,
      bool persistent = true,
      ShapeBorder? shape,
      Clip? clipBehavior,
      Color? barrierColor = Colors.black38,
      bool? ignoreSafeArea,
      bool isScrollControlled = false,
      bool useRootNavigator = false,
      bool isDismissible = true,
      bool enableDrag = true,
      RouteSettings? settings,
      Duration? enterBottomSheetDuration,
      Duration? exitBottomSheetDuration,
      bool hideKeyboard = true}) {
    if (hideKeyboard) {
      hideKeyBoard();
    }
    return Get.bottomSheet(bottomSheet,
        backgroundColor: backgroundColor,
        elevation: elevation,
        persistent: persistent,
        shape: shape,
        clipBehavior: clipBehavior,
        barrierColor: barrierColor,
        ignoreSafeArea: ignoreSafeArea,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        settings: settings,
        enterBottomSheetDuration: enterBottomSheetDuration,
        exitBottomSheetDuration: exitBottomSheetDuration);
  }

  ///buildContext is overlayContext
  showToast(String content,
      {BuildContext? buildContext, TGravity gravity = TGravity.CENTER, int duration = Toast.SHORT_LENGTH}) {
    Toast.show(buildContext ?? Get.overlayContext!, content, gravity: gravity, duration: duration);
  }

  Future<T?> showToastDialog<T>(bool state, String content,
      {Duration duration = const Duration(milliseconds: 2500), bool? autoDismiss}) {
    return showDialog(ToastDialog(state, content, duration: duration, autoDismiss: autoDismiss));
  }

  Future<T?> showLoadingDialog<T>(
      {String? content, bool outsideDismiss = false, bool onBackDismiss = true, LoadingController? loadingController}) {
    return showDialog(
        LoadingDialog(content,
            outsideDismiss: outsideDismiss, onBackDismiss: onBackDismiss, controller: loadingController),
        barrierDismissible: false);
  }
}

extension GetExt on GetInterface {
  ///关闭 键盘
  hideKeyBoard([BuildContext? overlayContext]) {
    var context = overlayContext ?? Get.overlayContext;
    if (null != context) {
      Utils.hideKeyboardUnfocus(context);
    }
  }

  ///关闭当前页面第一个弹窗  dialog or bottomSheet or snakeBar
  dismiss<T>({T? result, int? id}) {
    if (Get.routing.route is! GetPageRoute) {
      Get.back<T>(result: result, closeOverlays: false, canPop: true, id: id);
    }
  }

  ///关闭当前 所有弹窗 包括 dialog bottomSheet snakeBar
  dismissAll() {
    if (Get.isSnackbarOpen) {
      SnackbarController.cancelAllSnackbars();
    }
    Get.until((route) => route is GetPageRoute);
  }

  ///关闭当前页面 包括 当前页面的 dialog  bottomSheet snakeBar
  backPage<T>({T? result, bool canPop = true, int? id}) {
    // dismissAll();
    // Get.back(result: result, canPop: true, closeOverlays: false, id: id);
    Get.back(result: result, canPop: true, closeOverlays: true, id: id);
  }
}
