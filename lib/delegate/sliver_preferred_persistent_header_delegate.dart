import 'package:flutter/material.dart';

class SliverPreferredPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;

  SliverPreferredPersistentHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
