import 'package:flutter/cupertino.dart';
import 'package:lifestep/features/main_app/domain/usecases/logger/project_logger.dart';
import 'package:lifestep/features/tools/constants/page_key.dart';

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