import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/general/padding/page_padding.dart';

class HomeSkeletonGridViewWidget extends StatelessWidget {
  final int itemCount;
  final Widget child;
  const HomeSkeletonGridViewWidget({Key? key, this.itemCount = 4, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: GridView.builder(
        itemCount: itemCount,
        padding: const PagePadding.leftRight16(),
        physics: const ScrollPhysics(),
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
