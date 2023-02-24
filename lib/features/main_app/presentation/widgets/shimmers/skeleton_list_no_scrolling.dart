import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';


class SkeletonNoScrollingListWidget extends StatelessWidget {
  final int itemCount;
  final Widget child;
  const SkeletonNoScrollingListWidget({Key? key, this.itemCount = 4, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              for(int i = 0; i < itemCount; i++)
                child,
            ],
          )
      ),
    );
  }
}
