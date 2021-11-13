import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dialog/dialog.dart';
import '../utils/util.dart';

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
  showToast(String content, {BuildContext? buildContext, TGravity gravity = TGravity.CENTER, int duration = Toast.SHORT_LENGTH}) {
    Toast.show(buildContext ?? Get.overlayContext!, content, gravity: gravity, duration: duration);
  }

  Future<T?> showToastDialog<T>(bool state, String content) {
    return showDialog(ToastDialog(state, content));
  }

  Future<T?> showLoadingDialog<T>({String? content, bool outsideDismiss = false, bool onBackDismiss = true}) {
    return showDialog(LoadingDialog(content, outsideDismiss: outsideDismiss, onBackDismiss: onBackDismiss), barrierDismissible: false);
  }
}

extension GetExt on GetInterface {
  void hideKeyBoard() {
    var overlayContext = Get.overlayContext;
    if (null != overlayContext) {
      Utils.hideKeyboardUnfocus(overlayContext);
    }
  }

  ///关闭当前页面第一个弹窗  dialog or bottomSheet or snakeBar
  dismissDialog<T>({T? result, int? id}) {
    if (Get.isOverlaysOpen) {
      Get.back<T>(result: result, closeOverlays: false, canPop: true, id: id);
    }
  }

  ///关闭当前页面的 所有弹窗 包括 dialog bottomSheet snakeBar
  dismissPagePopupDialogs() {
    if (Get.isOverlaysOpen) {
      navigator?.popUntil((route) {
        return (Get.isOverlaysClosed);
      });
    }
  }

  ///关闭当前页面 包括 当前页面的 dialog  bottomSheet snakeBar
  backPage<T>({T? result, bool canPop = true, int? id}) => Get.back(result: result, closeOverlays: true, canPop: canPop, id: id);
}
