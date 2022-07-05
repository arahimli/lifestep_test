import 'package:flutter/material.dart';
import 'package:lifestep/config/scroll_behavior.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 16),
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
