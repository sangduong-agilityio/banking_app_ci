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
  late Animation _colorAnimation;

  @override
  void initState() {
    init(widget.context);
    super.initState();
  }

  void init(BuildContext context) {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.durationAnimated ?? const Duration(milliseconds: 600),
    );
    _colorAnimation = ColorTween(
      begin: widget.startColor ?? context.colorScheme.surface,
      end: widget.endColor ?? context.colorScheme.outlineVariant,
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

class ShimmerListView extends StatelessWidget {
  const ShimmerListView({
    super.key,
    this.height = 50,
    this.itemCount = 1,
  });

  final double height;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final adjustedHeight = isTablet ? height * 1.5 : height;

    return Center(
      child: Wrap(
        runSpacing: 20.w,
        children: List<Widget>.filled(
          itemCount,
          LSShimmerLoading(
            width: MediaQuery.of(context).size.width,
            height: adjustedHeight.h,
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

  final int itemCount;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final adjustedWidth = isTablet ? width * 1.2 : width;
    final adjustedHeight = isTablet ? height * 1.2 : height;

    return SizedBox(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: isTablet ? 300 : 200,
          childAspectRatio: isTablet ? 4 / 3 : 3 / 2,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
        ),
        itemCount: itemCount,
        itemBuilder: (context, _) {
          return LSShimmerLoading(
            width: adjustedWidth.w,
            height: adjustedHeight.h,
            context: context,
          );
        },
      ),
    );
  }
}
