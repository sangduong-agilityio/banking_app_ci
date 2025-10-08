import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// A lightweight shimmer effect without external dependencies.
///
/// Wrap any placeholder widget with [BAShimmerLoading] to display an animated
/// gradient shimmer while loading.
class BAShimmerLoading extends StatefulWidget {
  /// Creates a [BAShimmerLoading] widget.
  const BAShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration,
  });

  /// The widget to display the shimmer effect on.
  final Widget child;

  /// The base color of the shimmer effect.
  final Color? baseColor;

  /// The highlight color of the shimmer effect.
  final Color? highlightColor;

  /// The duration of the shimmer animation.
  final Duration? duration;

  @override
  State<BAShimmerLoading> createState() => _BAShimmerLoadingState();
}

/// The state for a [BAShimmerLoading] widget.
class _BAShimmerLoadingState extends State<BAShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = widget.baseColor ?? Colors.grey.shade300;
    final Color highlightColor = widget.highlightColor ?? Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            final double width = bounds.width;
            final double dx = (width + width) * _controller.value - width;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                baseColor,
                baseColor,
                highlightColor,
                baseColor,
                baseColor,
              ],
              stops: const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
              transform: GradientTranslation(dx),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A [GradientTransform] that translates the gradient by a given [dx] value.
class GradientTranslation extends GradientTransform {
  /// Creates a [GradientTranslation] object.
  const GradientTranslation(this.dx);

  /// The horizontal translation value.
  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()..translate(dx, 0.0, 0.0);
  }
}

/// A skeleton placeholder for a greeting app bar.
class GreetingAppBarSkeleton extends StatelessWidget {
  /// Creates a [GreetingAppBarSkeleton] widget.
  const GreetingAppBarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      color: context.colorScheme.secondary,
      child: SafeArea(
        bottom: false,
        child: BAShimmerLoading(
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 120,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A skeleton placeholder for a card.
class BACardSkeleton extends StatelessWidget {
  /// Creates a [BACardSkeleton] widget.
  const BACardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BAShimmerLoading(
      child: Container(
        height: 204,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bar(width: 120, height: 16),
            const SizedBox(height: 12),
            _bar(width: 80, height: 12),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bar(width: 100, height: 14),
                _bar(width: 60, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single bar for the skeleton.
  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

/// A skeleton placeholder for a grid.
class BAGridSkeleton extends StatelessWidget {
  /// Creates a [BAGridSkeleton] widget.
  const BAGridSkeleton({
    super.key,
    this.crossAxisCount = 3,
    this.itemCount = 9,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.childAspectRatio = 1,
  });

  /// The number of columns in the grid.
  final int crossAxisCount;

  /// The number of items in the grid.
  final int itemCount;

  /// The spacing between columns.
  final double crossAxisSpacing;

  /// The spacing between rows.
  final double mainAxisSpacing;

  /// The aspect ratio of the children.
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const _GridTileSkeleton(),
    );
  }
}

/// A skeleton placeholder for a grid tile.
class _GridTileSkeleton extends StatelessWidget {
  /// Creates a [_GridTileSkeleton] widget.
  const _GridTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return BAShimmerLoading(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCBD5E0).withAlpha(150),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A skeleton placeholder for a user profile.
class UserProfileSkeleton extends StatelessWidget {
  /// Creates a [UserProfileSkeleton] widget.
  const UserProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BAShimmerLoading(
      child: Column(
        children: [
          // Profile Image Skeleton
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 12),

          // Username Skeleton
          Container(
            width: 120,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}

/// A skeleton placeholder for a list of accounts.
class AccountListSkeleton extends StatelessWidget {
  /// Creates an [AccountListSkeleton] widget.
  const AccountListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              const UserProfileSkeleton(),
              const SizedBox(height: 32),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) => const AccountCardSkeleton(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A skeleton placeholder for an account card.
class AccountCardSkeleton extends StatelessWidget {
  /// Creates an [AccountCardSkeleton] widget.
  const AccountCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BAShimmerLoading(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bar(width: 70, height: 16),
                  _bar(width: 110, height: 16),
                ],
              ),
              const SizedBox(height: 12),
              _infoRow(),
              const SizedBox(height: 8),
              _infoRow(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a single row of information for the skeleton.
  Widget _infoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_bar(width: 100, height: 12), _bar(width: 80, height: 12)],
    );
  }

  /// Builds a single bar for the skeleton.
  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
