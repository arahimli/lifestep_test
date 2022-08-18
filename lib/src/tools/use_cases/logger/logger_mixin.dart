import 'package:flutter/cupertino.dart';
import 'package:lifestep/src/tools/constants/page_key.dart';
import 'package:lifestep/src/tools/use_cases/logger/project_logger.dart';

mixin LoggerMixin<T extends StatefulWidget> on State<T>{
  PageKeyModel get pageKey;
  void init();
  // void disp();
  @override
  void initState() {
    super.initState();
    ProjectCustomLog.instance.sendData(pageKey);
    init();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   ProjectCustomLog.instance.sendData(pageKey);
  //   disp();
  // }
}