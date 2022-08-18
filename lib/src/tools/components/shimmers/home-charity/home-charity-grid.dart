import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';

class HomeSkeletonGridViewWidget extends StatelessWidget {
  final int itemCount;
  final Widget child;
  const HomeSkeletonGridViewWidget({Key? key, this.itemCount: 4, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: GridView.builder(
        itemCount: itemCount,
        padding: PagePadding.leftRight16(),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // childAspectRatio: 0.601,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        itemBuilder: (context, index){
          return child;
        },
      ),
    );
  }
}
