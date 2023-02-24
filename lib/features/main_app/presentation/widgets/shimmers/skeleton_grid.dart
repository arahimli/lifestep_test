import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';

class SkeletonGridViewWidget extends StatelessWidget {
  final int itemCount;
  final Widget child;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  const SkeletonGridViewWidget({Key? key, this.itemCount = 4, required this.child, this.crossAxisSpacing, this.mainAxisSpacing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: GridView.builder(
        itemCount: itemCount,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // childAspectRatio: 0.601,
          mainAxisSpacing: mainAxisSpacing ?? 4.0,
          crossAxisSpacing: crossAxisSpacing ?? 4.0,
        ),
        itemBuilder: (context, index){
          return child;
        },
      ),
    );
  }
}
