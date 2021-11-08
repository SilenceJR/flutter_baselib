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
      bool dismissLast = true,
      bool hideKeyboard = true}) {
    if (hideKeyboard) {
      var overlayContext = Get.overlayContext;
      if (null != overlayContext) {
        Utils.hideKeyboardUnfocus(overlayContext);
      }
    }
    if (dismissLast) {
      Get.dismissDialog();
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
      bool dismissLast = true,
      bool hideKeyboard = true}) {
    if (hideKeyboard) {
      var overlayContext = Get.overlayContext;
      if (null != overlayContext) {
        Utils.hideKeyboardUnfocus(overlayContext);
      }
    }
    if (dismissLast) {
      Get.dismissDialog();
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

  Future<T?> showToastDialog<T>(bool state, String content, {bool dismissLast = true}) {
    return showDialog(ToastDialog(state, content), dismissLast: dismissLast);
  }

  Future<T?> showLoadingDialog<T>({String? content, bool outsideDismiss = false, bool onBackDismiss = true, bool dismissLast = true}) {
    return showDialog(LoadingDialog(content, outsideDismiss: outsideDismiss, onBackDismiss: onBackDismiss),
        barrierDismissible: false, dismissLast: dismissLast);
  }

  dismissDialog<T>({T? result, bool closeOverlays = false, bool canPop = true, int? id}) {
    if (Get.isOverlaysOpen) {
      Get.back(result: result, closeOverlays: closeOverlays, id: id);
    }
  }
}
