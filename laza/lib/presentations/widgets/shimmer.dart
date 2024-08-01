import 'package:flutter/material.dart';
import 'package:laza/core/extensions/context_extensions.dart';

class LSShimmerLoading extends StatefulWidget {
  final double width;

  final double height;

  final Color? startColor;

  final Color? endColor;

  final BorderRadius borderRadius;

  final Duration? durationAnimated;

  final BuildContext context;

  const LSShimmerLoading({
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

  factory LSShimmerLoading.round({
    required double size,
    Color? startColor,
    Color? endColor,
    Duration durationAnimated = const Duration(milliseconds: 600),
    required BuildContext context,
  }) =>
      LSShimmerLoading(
        height: size,
        width: size,
        borderRadius: BorderRadius.all(
          Radius.circular(size / 2),
        ),
        startColor: startColor ?? context.colorScheme.surface,
        endColor: endColor ?? context.colorScheme.outlineVariant,
        durationAnimated: durationAnimated,
        context: context,
      );

  @override
  State<LSShimmerLoading> createState() => _LSShimmerLoadingState();
}

class _LSShimmerLoadingState extends State<LSShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // Animation which will hold the ColorTween values
  late Animation _colorAnimation;

  @override
  void initState() {
    init(widget.context);
    super.initState();
  }

  void init(BuildContext context) {
    // Initializing AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: widget.durationAnimated ?? const Duration(milliseconds: 600),
    );
    // ColorTween Animation
    _colorAnimation = ColorTween(
      begin: widget.startColor ?? context.colorScheme.surface,
      end: widget.endColor ?? context.colorScheme.outlineVariant,
    ).animate(_animationController);

    // Trigger the animation only after build is rendered
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });

    // Adding listener to the AnimationController so that
    // we can put it in a loop based on it's status
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reverse the animation if it's completed
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Restart the animation if it's dismissed
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
    // Dispose the AnimationController when the widget is disposed
    _animationController.dispose();
    super.dispose();
  }
}

class ShimmerListView extends StatelessWidget {
  const ShimmerListView({
    super.key,
    this.height = 50,
    this.itemCount = 1,
  });

  // Height of shimmer
  final double height;

  // Number auto gen widget of shimmer
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        runSpacing: 20,
        children: List<Widget>.filled(
          itemCount,
          LSShimmerLoading(
            width: MediaQuery.of(context).size.width,
            height: height.h,
            context: context,
          ),
        ),
      ),
    );
  }
}

class ShimmerGridView extends StatelessWidget {
  const ShimmerGridView({
    super.key,
    this.itemCount = 6,
    this.height = 203,
    this.width = 160,
  });

  // Count of item shimmer widget
  final int itemCount;

  /// Width of item
  final double width;

  /// Height of item
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: itemCount,
        itemBuilder: (context, _) {
          return LSShimmerLoading(
            width: width,
            height: height,
            context: context,
          );
        },
      ),
    );
  }
}
