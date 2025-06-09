import 'package:flutter/material.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/utils/responsive.dart';

class TAShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final Color? startColor;
  final Color? endColor;
  final BorderRadius borderRadius;
  final Duration? durationAnimated;
  final BuildContext context;

  const TAShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    required this.context,
    this.startColor,
    this.endColor,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(8),
    ),
    this.durationAnimated,
  });

  factory TAShimmerLoading.round({
    required double size,
    Color? startColor,
    Color? endColor,
    Duration durationAnimated = const Duration(seconds: 100),
    required BuildContext context,
  }) =>
      TAShimmerLoading(
        height: size,
        width: size,
        borderRadius: BorderRadius.all(
          Radius.circular(size / 2),
        ),
        startColor: startColor ?? context.colorScheme.primary,
        endColor: endColor ?? context.colorScheme.primary,
        durationAnimated: durationAnimated,
        context: context,
      );

  @override
  State<TAShimmerLoading> createState() => _TAShimmerLoadingState();
}

class _TAShimmerLoadingState extends State<TAShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorAnimation;

  @override
  void initState() {
    init(widget.context);
    super.initState();
  }

  void init(BuildContext context) {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.durationAnimated ?? const Duration(seconds: 100),
    );
    _colorAnimation = ColorTween(
      begin: widget.startColor ?? context.colorScheme.primary,
      end: widget.endColor ?? context.colorScheme.primary,
    ).animate(_animationController);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Shimmer for the hero banner section
class ShimmerHeroBanner extends StatelessWidget {
  const ShimmerHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 16,
              bottom: 16,
            ),
            child: TAShimmerLoading(
              width: 300,
              height: 165,
              context: context,
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for category grid
class ShimmerCategoryGrid extends StatelessWidget {
  const ShimmerCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return TAShimmerLoading(
          width: 80,
          height: 80,
          context: context,
        );
      },
    );
  }
}

/// Shimmer for product cards in a horizontal list
class ShimmerProductList extends StatelessWidget {
  const ShimmerProductList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: ShimmerProductCard(),
          );
        },
      ),
    );
  }
}

/// Shimmer for a single product card
class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.colorScheme.onPrimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TAShimmerLoading(
              width: 160,
              height: 120,
              context: context,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, top: 8, right: 10),
            child: TAShimmerLoading(
              width: 100,
              height: 16,
              context: context,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TAShimmerLoading.round(
                      size: 24,
                      context: context,
                    ),
                    SizedBox(width: 4),
                    TAShimmerLoading(
                      width: 50,
                      height: 16,
                      context: context,
                    ),
                  ],
                ),
                TAShimmerLoading(
                  width: 40,
                  height: 16,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for product list grid view
class ShimmerProductGrid extends StatelessWidget {
  final int itemCount;

  const ShimmerProductGrid({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: TAResponsive.orientationSizeOf(
          context,
          portrait: 2,
          landscape: 4,
        ),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(20),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TAShimmerLoading(
                  width: double.infinity,
                  height: 120,
                  context: context,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TAShimmerLoading(
                  width: 100,
                  height: 16,
                  context: context,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TAShimmerLoading(
                  width: 60,
                  height: 16,
                  context: context,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
