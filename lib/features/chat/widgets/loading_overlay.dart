import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum LoadingStatus {
  loading,
  success,
  error,
}

class LoadingOverlay extends StatefulWidget {
  final LoadingStatus status;
  final String message;
  final VoidCallback? onDismiss;

  const LoadingOverlay({
    Key? key,
    required this.status,
    required this.message,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.status != LoadingStatus.loading) {
      _controller.forward().then((_) {
        if (widget.status == LoadingStatus.success && widget.onDismiss != null) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() => _showOverlay = false);
            widget.onDismiss!();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showOverlay) return const SizedBox.shrink();

    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimation(),
                const SizedBox(height: 16),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (widget.status == LoadingStatus.error)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextButton(
                      onPressed: widget.onDismiss,
                      child: const Text('Dismiss'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    switch (widget.status) {
      case LoadingStatus.loading:
        return const SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.success:
        return Lottie.asset(
          'assets/animations/success.json',
          width: 100,
          height: 100,
          controller: _controller,
          repeat: false,
        );
      case LoadingStatus.error:
        return Lottie.asset(
          'assets/animations/error.json',
          width: 100,
          height: 100,
          controller: _controller,
          repeat: false,
        );
    }
  }
}