import 'package:flutter/material.dart';
import 'package:flutter_app_local_auth/app/modules/login/controllers/login_controller.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  // Get.put(LoginController());
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
