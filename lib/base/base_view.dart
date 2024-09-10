import 'package:flutter/material.dart';

import 'base.dart';

export 'package:get/get.dart'
    hide
        FormData,
        GetNumUtils,
        GetConnect,
        GetConnectInterface,
        GetHttpClient,
        MultipartFile,
        Response;

abstract class BaseGetView<T extends BaseGetController> extends GetView<T> {
  const BaseGetView({super.key});

  PageStatus get pageStatus => controller.pageStatus.value;
}

abstract class BaseGetFullView<T extends BaseGetController>
    extends StatefulWidget {
  const BaseGetFullView({super.key});

  T get controller;

  PageStatus get pageStatus => controller.pageStatus.value;
}
