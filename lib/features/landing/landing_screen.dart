import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/clipper.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BAScaffold(
      backgroundColor: BAAppColors.primaryGradient.colors.last,
      body: Container(
        decoration: const BoxDecoration(gradient: BAAppColors.primaryGradient),
        child: Stack(
          children: const [CreditCard(), BackgroundShapes(), Description()],
        ),
      ),
      bottomNavigationBar: ClipPath(
        clipper: WaveClipper(flip: true, reverse: true),
        child: Container(
          height: 110,
          decoration: const BoxDecoration(
            gradient: BAAppColors.primaryGradient,
          ),
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.only(right: 32, bottom: 20),
          child: const _ActionButton(),
        ),
      ),
    );
  }
}

class CreditCard extends StatelessWidget {
  const CreditCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 180,
      left: 0,
      right: 0,
      child: Center(
        child: Transform.rotate(
          angle: -0.7,
          child: Container(
            width: 290,
            height: 190,
            decoration: BoxDecoration(
              gradient: BAAppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                const _CardCircles(),
                Positioned(bottom: 20, left: 20, child: _CardDetailsGraphic()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardCircles extends StatelessWidget {
  const _CardCircles();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: SizedBox(
        width: 48,
        height: 32,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(left: 0, child: _Circle(size: 28)),
            Positioned(right: 0, child: _Circle(size: 28)),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  const _Circle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CardDetailsGraphic extends StatelessWidget {
  const _CardDetailsGraphic();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _DetailBlock(width: 50, height: 32, borderRadius: 6),
          SizedBox(height: 16),
          _DetailBlock(width: 80, height: 8),
          SizedBox(height: 16),
          Row(
            children: [
              _DetailBlock(width: 40, height: 8),
              SizedBox(width: 4),
              _DetailBlock(width: 20, height: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const _DetailBlock({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius != null
            ? BorderRadius.circular(borderRadius!)
            : null,
      ),
    );
  }
}

class BackgroundShapes extends StatelessWidget {
  const BackgroundShapes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _RotatedShape(top: 160, left: -100, width: 200, height: 150),
        _RotatedShape(top: 210, right: -70, width: 220, height: 220),
      ],
    );
  }
}

class _RotatedShape extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double width;
  final double height;

  const _RotatedShape({
    this.top,
    this.left,
    this.right,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: -0.7,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 30,
      right: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.landingTitle,
            style: context.displaySmall?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.current.landingDescription,
            style: context.titleMedium?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(
        onPressed: () => context.pushNamed(BAPaths.signIn.name),
        icon: const Icon(Icons.arrow_forward, color: Colors.black, size: 24),
      ),
    );
  }
}
