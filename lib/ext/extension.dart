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
      bool dismissLast = true}) {
    Utils.hideKeyboard();
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

  Future<T?> showBottomSheet<T>(Widget bottomsheet,
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
      bool dismissLast = true}) {
    Utils.hideKeyboard();
    if (dismissLast) {
      Get.dismissDialog();
    }
    return Get.bottomSheet(bottomsheet,
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

  showToast(String content, {TGravity gravity = TGravity.CENTER, int duration = Toast.SHORT_LENGTH}) {
    Toast.show(Get.overlayContext!, content, gravity: gravity, duration: duration);
  }

  Future<T?> showToastDialog<T>(bool state, String content, {VoidCallback? successCallback, bool dismissLast = true}) {
    return showDialog(ToastDialog(state, content, successCallback: successCallback), dismissLast: dismissLast);
  }

  Future<void> showLoadingDialog({String? content, bool outsideDismiss = false, bool onBackDismiss = true, bool dismissLast = true}) {
    return showDialog(LoadingDialog(content, outsideDismiss: outsideDismiss, onBackDismiss: onBackDismiss),
        barrierDismissible: false, dismissLast: dismissLast);
  }

  dismissDialog<T>({T? result, bool closeOverlays = false, bool canPop = true, int? id}) {
    if ((Get.isDialogOpen ?? false) || (Get.isBottomSheetOpen ?? false)) {
      Get.back(result: result, closeOverlays: closeOverlays, canPop: (Get.routing.isDialog ?? false) || (Get.routing.isBottomSheet ?? false), id: id);
    }
  }
}
