import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';


class SkeletonListWidget extends StatelessWidget {
  final int itemCount;
  final Widget child;
  const SkeletonListWidget({Key? key, this.itemCount: 4, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: SingleChildScrollView(
          child: Container(
            // padding: PagePadding.leftRight16(),
            child: Column(
              children: [
                for(int i = 0; i < itemCount; i++)
                  child,
              ],
            ),
          )
      ),
    );
  }
}
