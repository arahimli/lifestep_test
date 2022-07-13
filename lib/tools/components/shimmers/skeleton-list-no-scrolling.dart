import 'package:flutter/material.dart';
import 'package:lifestep/tools/components/shimmers/achievement_list_item.dart';
import 'package:lifestep/config/scroll_behavior.dart';


class SkeletonNoScrollingListWidget extends StatelessWidget {
  final int itemCount;
  final Widget child;
  const SkeletonNoScrollingListWidget({Key? key, this.itemCount: 4, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: SingleChildScrollView(
          physics: ScrollPhysics(),
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
