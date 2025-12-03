import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';

/// A widget that displays a stack of cards and allows the user to swipe
/// through them with a 3D animation.
class CardsSwiperWidget<T> extends StatefulWidget {
  /// The data for the cards to be displayed.
  final List<T> cardData;

  final Duration animationDuration;

  /// The duration of the downward drag animation.
  final Duration downDragDuration;

  /// The duration of the card collection animation.
  final Duration collectionDuration;

  /// The maximum distance the user can drag a card up or down.
  final double maxDragDistance;

  /// The limit for dragging a card down before it bounces back.
  final double dragDownLimit;

  /// The threshold value for completing the swipe animation.
  final double thresholdValue;

  /// A callback that is called when the card changes.
  final void Function(int)? onCardChange;

  /// A builder for the card widgets.
  final Widget Function(BuildContext context, int index, int visibleIndex)
  cardBuilder;

  /// A flag to indicate whether the card collection animation should start.
  final bool shouldStartCardCollectionAnimation;

  /// A callback that is called when the card collection animation is complete.
  final void Function(bool value) onCardCollectionAnimationComplete;

  // Animation parameters for the cards.
  final double topCardOffsetStart;
  final double topCardOffsetEnd;
  final double topCardScaleStart;
  final double topCardScaleEnd;
  final double secondCardOffsetStart;
  final double secondCardOffsetEnd;
  final double secondCardScaleStart;
  final double secondCardScaleEnd;
  final double thirdCardOffsetStart;
  final double thirdCardOffsetEnd;
  final double thirdCardScaleStart;
  final double thirdCardScaleEnd;

  const CardsSwiperWidget({
    required this.cardData,
    required this.cardBuilder,
    this.animationDuration = const Duration(milliseconds: 600),
    this.downDragDuration = const Duration(milliseconds: 200),
    this.collectionDuration = const Duration(milliseconds: 1000),
    this.maxDragDistance = 220.0,
    this.dragDownLimit = -40.0,
    this.thresholdValue = 0.3,
    this.onCardChange,
    this.topCardOffsetStart = 0.0,
    this.topCardOffsetEnd = -15.0,
    this.topCardScaleStart = 1.0,
    this.topCardScaleEnd = 0.9,
    this.secondCardOffsetStart = 15.0,
    this.secondCardOffsetEnd = 0.0,
    this.secondCardScaleStart = 0.94,
    this.secondCardScaleEnd = 1.0,
    this.thirdCardOffsetStart = 25.0,
    this.thirdCardOffsetEnd = 7.0,
    this.thirdCardScaleStart = 0.90,
    this.thirdCardScaleEnd = 0.96,
    this.shouldStartCardCollectionAnimation = false,
    required this.onCardCollectionAnimationComplete,
    super.key,
  });

  @override
  State<CardsSwiperWidget<T>> createState() => _CardsSwiperWidgetState<T>();
}

class _CardsSwiperWidgetState<T> extends State<CardsSwiperWidget<T>>
    with TickerProviderStateMixin {
  // Animation Controllers
  late final AnimationController _controller;
  late final Animation<double> _yOffsetAnimation;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _animation;
  late final AnimationController _downDragController;
  late Animation<double> _downDragAnimation;
  AnimationController? _cardCollectionAnimationController;
  Animation<double>? _cardCollectionyOffsetAnimation;

  // State Variables
  double _startAnimationValue = 0.0;
  double _dragStartPosition = 0.0;
  double _dragOffset = 0.0;
  bool _isCardSwitched = false;
  bool _hasReachedHalf = false;
  bool _isAnimationBlocked = false;
  bool _shouldPlayVibration = true;

  late List<T> _cardData;
  Timer? _debounceTimer;

  // Cached Widgets
  Widget? _topCardWidget;
  int? _topCardIndex;
  Widget? _secondCardWidget;
  int? _secondCardIndex;
  Widget? _thirdCardWidget;
  int? _thirdCardIndex;
  Widget? _poppedCardWidget;
  int? _poppedCardIndex;

  @override
  void initState() {
    super.initState();
    _cardData = List.from(widget.cardData);
    _initializeAnimations();
    _setupAnimationListener();
    _initializeCollectionAnimation();
    _updateCardWidgets();
  }

  @override
  void didUpdateWidget(CardsSwiperWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cardData != oldWidget.cardData) {
      _resetAnimations();
      _cardData = List.from(widget.cardData);
    }
    if (widget.shouldStartCardCollectionAnimation !=
        oldWidget.shouldStartCardCollectionAnimation) {
      _handleCollectionAnimationChange();
    }
    _updateCardWidgets();
  }

  @override
  void dispose() {
    _controller.dispose();
    _downDragController.dispose();
    _debounceTimer?.cancel();
    _cardCollectionAnimationController?.dispose();
    super.dispose();
  }

  /// Initializes the animations for the card swiper.
  void _initializeAnimations() {
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _yOffsetAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 0.5),
        weight: 45.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.5, end: 0.0),
        weight: 55.0,
      ),
    ]).animate(_animation);

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: -180.0,
    ).animate(_animation);

    _downDragController = AnimationController(
      duration: widget.downDragDuration,
      vsync: this,
    );

    _downDragAnimation =
        Tween<double>(begin: 0.0, end: 0.0).animate(_downDragController)
          ..addListener(() {
            _dragOffset = _downDragAnimation.value;
          });
  }

  /// Sets up the listener for the swipe animation.
  void _setupAnimationListener() {
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isCardSwitched = false;
        _controller.reset();
        _hasReachedHalf = false;
      }
    });

    _controller.addListener(() {
      if (_cardData.length > 1) {
        _handleCardSwitchAtMidpoint();
      }
    });
  }

  /// Handles the card switch when the animation reaches the midpoint.
  void _handleCardSwitchAtMidpoint() {
    if (!_isCardSwitched && _controller.value >= 0.5) {
      if (_debounceTimer?.isActive ?? false) {
        _isCardSwitched = true;
        return;
      }

      _performCardSwitch();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {});
    }
  }

  /// Performs the card switch by moving the top card to the bottom of the stack.
  void _performCardSwitch() {
    var firstCard = _cardData.removeAt(0);
    _poppedCardIndex = widget.cardData.indexOf(firstCard);
    if (_poppedCardIndex != null && _poppedCardIndex! >= 0) {
      _poppedCardWidget = widget.cardBuilder(context, _poppedCardIndex!, -1);
    }
    _cardData.add(firstCard);

    _playCardSwitchVibration();
    _isCardSwitched = true;
    _updateCardWidgets();

    widget.onCardChange?.call(widget.cardData.indexOf(_cardData[0]));
  }

  /// Initializes the card collection animation.
  void _initializeCollectionAnimation() {
    if (widget.shouldStartCardCollectionAnimation) {
      _cardCollectionAnimationController = AnimationController(
        duration: widget.collectionDuration,
        vsync: this,
      );

      _cardCollectionyOffsetAnimation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(
            CurvedAnimation(
              parent: _cardCollectionAnimationController!,
              curve: Curves.easeOutCubic,
            ),
          );

      _cardCollectionAnimationController!.forward().then(
        (_) => widget.onCardCollectionAnimationComplete(false),
      );
    }
  }

  /// Handles the change in the card collection animation status.
  void _handleCollectionAnimationChange() {
    if (widget.shouldStartCardCollectionAnimation) {
      _cardCollectionAnimationController = AnimationController(
        duration: widget.collectionDuration,
        vsync: this,
      );

      _cardCollectionyOffsetAnimation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(
            CurvedAnimation(
              parent: _cardCollectionAnimationController!,
              curve: Curves.easeOutCubic,
            ),
          );

      _cardCollectionAnimationController!.forward().then(
        (_) => widget.onCardCollectionAnimationComplete(false),
      );
    } else {
      _cardCollectionAnimationController?.dispose();
      _cardCollectionAnimationController = null;
      _cardCollectionyOffsetAnimation = null;
    }
  }

  /// Resets the animations to their initial state.
  void _resetAnimations() {
    _controller.stop();
    _downDragController.stop();
    _controller.reset();
    _downDragController.reset();
    _isCardSwitched = false;
    _hasReachedHalf = false;
    _startAnimationValue = 0.0;
    _dragStartPosition = 0.0;
    _dragOffset = 0.0;
  }

  /// Updates the card widgets based on the current card data.
  void _updateCardWidgets() {
    // Top card
    if (_cardData.isNotEmpty) {
      _topCardIndex = widget.cardData.indexOf(_cardData[0]);
      if (_topCardIndex != null && _topCardIndex! >= 0) {
        _topCardWidget = widget.cardBuilder(context, _topCardIndex!, 0);
      }
    } else {
      _topCardIndex = null;
      _topCardWidget = null;
    }

    // Second card
    if (_cardData.length > 1) {
      _secondCardIndex = widget.cardData.indexOf(_cardData[1]);
      if (_secondCardIndex != null && _secondCardIndex! >= 0) {
        _secondCardWidget = widget.cardBuilder(context, _secondCardIndex!, 1);
      }
    } else {
      _secondCardIndex = null;
      _secondCardWidget = null;
    }

    // Third card
    if (_cardData.length > 2) {
      _thirdCardIndex = widget.cardData.indexOf(_cardData[2]);
      if (_thirdCardIndex != null && _thirdCardIndex! >= 0) {
        _thirdCardWidget = widget.cardBuilder(context, _thirdCardIndex!, 2);
      }
    } else {
      _thirdCardIndex = null;
      _thirdCardWidget = null;
    }
  }

  /// Handles the start of a vertical drag gesture.
  void _onVerticalDragStart(DragStartDetails details) {
    if (_shouldIgnoreGesture()) return;

    _isAnimationBlocked = false;
    _startAnimationValue = _controller.value;
    _dragStartPosition = details.globalPosition.dy;
    _controller.stop(canceled: false);
    _downDragController.stop();
    _hasReachedHalf = false;
  }

  /// Handles the update of a vertical drag gesture.
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_shouldIgnoreGesture() || _hasReachedHalf || _isAnimationBlocked) {
      return;
    }

    double dragDistance = _dragStartPosition - details.globalPosition.dy;

    if (dragDistance >= 0) {
      _handleUpwardDrag(dragDistance);
    } else {
      _handleDownwardDrag(dragDistance);
    }
  }

  /// Handles the end of a vertical drag gesture.
  void _onVerticalDragEnd(DragEndDetails details) {
    if (_shouldIgnoreGesture() || _isAnimationBlocked) return;

    if (_dragOffset != 0.0) {
      _animateDragOffsetToZero();
    } else if (!_hasReachedHalf) {
      _completeOrRevertAnimation();
    }

    _shouldPlayVibration = true;
  }

  /// Determines whether the gesture should be ignored.
  bool _shouldIgnoreGesture() {
    return _controller.isAnimating ||
        _downDragController.isAnimating ||
        widget.shouldStartCardCollectionAnimation ||
        _cardData.length == 1;
  }

  /// Handles the upward drag gesture.
  void _handleUpwardDrag(double dragDistance) {
    double dragFraction = dragDistance / widget.maxDragDistance;
    double newValue = (_startAnimationValue + dragFraction).clamp(0.0, 1.0);
    _controller.value = newValue;
    _dragOffset = 0.0;

    if (_controller.value >= 0.5 && !_hasReachedHalf) {
      _hasReachedHalf = true;
      _animateToCompletion();
    }
  }

  /// Handles the downward drag gesture.
  void _handleDownwardDrag(double dragDistance) {
    _controller.value = _startAnimationValue;
    double downDragOffset = dragDistance.clamp(widget.dragDownLimit, 0.0);
    _dragOffset = -downDragOffset;

    if (downDragOffset == widget.dragDownLimit && _shouldPlayVibration) {
      _playCardBlockVibration();
      _shouldPlayVibration = false;
    }
  }

  /// Animates the card to the completion of the swipe.
  void _animateToCompletion() {
    final double remaining = 1.0 - _controller.value;
    final int duration =
        ((_controller.duration?.inMilliseconds ?? 0) * remaining).round();

    if (duration > 0) {
      _controller.animateTo(
        1.0,
        duration: Duration(milliseconds: duration),
        curve: Curves.easeOut,
      );
      _isAnimationBlocked = true;
    } else {
      _controller.value = 1.0;
    }
  }

  /// Animates the drag offset back to zero.
  void _animateDragOffsetToZero() {
    _downDragAnimation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: _downDragController, curve: Curves.easeOutCubic),
    );
    _downDragController.forward(from: 0.0);
  }

  /// Completes or reverts the animation based on the threshold value.
  void _completeOrRevertAnimation() {
    if (_controller.value >= widget.thresholdValue) {
      final double remaining = 1.0 - _controller.value;
      final int duration =
          ((_controller.duration?.inMilliseconds ?? 0) * remaining).round();

      if (duration > 0) {
        _controller.animateTo(
          1.0,
          duration: Duration(milliseconds: duration),
          curve: Curves.easeOut,
        );
        _isAnimationBlocked = true;
      } else {
        _controller.value = 1.0;
      }
    } else {
      final int duration =
          ((_controller.duration?.inMilliseconds ?? 0) * _controller.value)
              .round();

      if (duration > 0) {
        _controller.animateBack(
          0.0,
          duration: Duration(milliseconds: duration),
          curve: Curves.easeOut,
        );
      } else {
        _controller.value = 0.0;
      }
    }
  }

  /// Plays a haptic feedback vibration for the card switch.
  void _playCardSwitchVibration() {
    HapticFeedback.lightImpact();
    Future.delayed(
      const Duration(milliseconds: 250),
      HapticFeedback.selectionClick,
    );
  }

  /// Plays a haptic feedback vibration when the card is blocked.
  void _playCardBlockVibration() {
    HapticFeedback.lightImpact();
    Future.delayed(
      const Duration(milliseconds: 100),
      HapticFeedback.lightImpact,
    );
    Future.delayed(
      const Duration(milliseconds: 300),
      HapticFeedback.mediumImpact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _controller,
            _downDragController,
            if (widget.shouldStartCardCollectionAnimation &&
                _cardCollectionAnimationController != null)
              _cardCollectionAnimationController!,
          ]),
          builder: (context, child) =>
              Stack(alignment: Alignment.center, children: _buildCardStack()),
        ),
      ),
    );
  }

  /// Builds the stack of cards.
  List<Widget> _buildCardStack() {
    if (_cardData.isEmpty) {
      return [const SizedBox.shrink()];
    }
    if (_cardData.length == 1) {
      return [_topCardWidget ?? const SizedBox.shrink()];
    }

    final yOffsetAnimationValue = _yOffsetAnimation.value;
    final rotation = _rotationAnimation.value;
    final totalYOffset = _calculateTotalYOffset(yOffsetAnimationValue);

    final cardCount = min(_cardData.length, 3);
    final stackChildren = <Widget>[];

    if (_isCardSwitched) {
      for (var i = 0; i < cardCount; i++) {
        stackChildren.add(
          i == 0
              ? _buildTopCard(totalYOffset, rotation)
              : _buildBackCard(cardCount - i),
        );
      }
    } else {
      for (var i = cardCount - 1; i >= 0; i--) {
        stackChildren.add(
          i == 0 ? _buildTopCard(totalYOffset, rotation) : _buildBackCard(i),
        );
      }
    }

    return stackChildren;
  }

  /// Calculates the total Y offset for the top card.
  double _calculateTotalYOffset(double yOffsetAnimationValue) {
    var totalYOffset =
        -yOffsetAnimationValue * widget.maxDragDistance +
        (_downDragController.isAnimating
            ? _downDragAnimation.value
            : _dragOffset);

    if (_controller.value >= 0.5) {
      totalYOffset += _cardData.length == 2
          ? widget.secondCardOffsetStart
          : widget.thirdCardOffsetStart;
    }

    return totalYOffset;
  }

  /// Builds the top card in the stack.
  Widget _buildTopCard(double yOffset, double rotation) {
    if (_topCardWidget == null) return const SizedBox.shrink();

    final cardWidget = _isCardSwitched && _cardData.length > 1
        ? (_poppedCardWidget ?? const SizedBox.shrink())
        : (_topCardWidget ?? const SizedBox.shrink());

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = _calculateTopCardScale();

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translateByVector3(Vector3(0.0, yOffset, 0.0))
            ..translateByVector3(
              Vector3(
                0.0,
                _isCardSwitched ? _calculateSwitchOffset(rotation) : 0,
                0.0,
              ),
            )
            ..setEntry(3, 2, 0.001)
            ..rotateX(rotation * pi / 180)
            ..scaleByVector3(Vector3(scale, scale, 1.0)),
          child: child,
        );
      },
      child: cardWidget,
    );
  }

  /// Calculates the scale of the top card.
  double _calculateTopCardScale() {
    final controllerValue = _controller.value;

    if (controllerValue > 0.5 || _cardData.length == 1) {
      return _cardData.length == 2 ? 0.95 : 0.9;
    }

    if (_cardData.length == 2) {
      if (controllerValue >= 0.45) {
        return 1.0 - 0.05 * ((controllerValue - 0.45) / 0.05);
      }
    } else {
      if (controllerValue >= 0.4) {
        return 1.0 - 0.1 * ((controllerValue - 0.4) / 0.1);
      }
    }

    return 1.0;
  }

  /// Calculates the offset for the card switch animation.
  double _calculateSwitchOffset(double rotation) {
    return (-widget.thirdCardOffsetStart) * ((rotation + 180) / 90);
  }

  /// Builds a back card in the stack.
  Widget _buildBackCard(int index) {
    if (_cardData.length <= 1 || index >= _cardData.length) {
      return const SizedBox.shrink();
    }

    final cardWidget = _getBackCardWidget(index);
    if (cardWidget == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final transforms = _calculateBackCardTransforms(index);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translateByVector3(Vector3(0.0, transforms.yOffset, 0.0))
            ..scaleByVector3(Vector3(transforms.scale, transforms.scale, 1.0)),
          child: child,
        );
      },
      child: cardWidget,
    );
  }

  /// Returns the widget for the back card at the given index.
  Widget? _getBackCardWidget(int index) {
    if (_isCardSwitched) {
      if (index == 1) return _topCardWidget;
      if (index == 2) return _secondCardWidget;
    } else {
      if (index == 1) return _secondCardWidget;
      if (index == 2) return _thirdCardWidget;
    }
    return null;
  }

  /// Calculates the transforms for the back card at the given index.
  _CardTransforms _calculateBackCardTransforms(int index) {
    final controllerValue = _controller.value;
    final initialOffset = _getInitialOffset(index);
    final initialScale = _getInitialScale(index);
    final targetScale = _getTargetScale(index);

    var yOffset = initialOffset;
    var scale = initialScale;

    if (controllerValue <= 0.5) {
      final progress = controllerValue / 0.5;
      yOffset = _cardData.length == 2
          ? initialOffset - widget.secondCardOffsetStart * progress
          : initialOffset - widget.thirdCardOffsetStart * progress;
      scale = initialScale;
    } else {
      final progress = Curves.easeOut.transform((controllerValue - 0.5) / 0.5);
      yOffset = _calculateBackCardYOffset(initialOffset, progress);
      scale = initialScale + (targetScale - initialScale) * progress;
    }

    if (widget.shouldStartCardCollectionAnimation &&
        _cardCollectionyOffsetAnimation != null) {
      yOffset = _applyCollectionAnimation(yOffset, index);
    }

    return _CardTransforms(yOffset: yOffset, scale: scale);
  }

  /// Returns the initial offset for the back card at the given index.
  double _getInitialOffset(int index) {
    if (_cardData.length == 2) return widget.secondCardOffsetStart;
    return index == 1
        ? widget.secondCardOffsetStart
        : widget.thirdCardOffsetStart;
  }

  /// Returns the initial scale for the back card at the given index.
  double _getInitialScale(int index) {
    if (_cardData.length == 2) return widget.secondCardScaleStart;
    return index == 1
        ? widget.secondCardScaleStart
        : widget.thirdCardScaleStart;
  }

  /// Returns the target scale for the back card at the given index.
  double _getTargetScale(int index) {
    if (_cardData.length == 2) return widget.secondCardScaleEnd;
    return index == 1 ? widget.secondCardScaleEnd : widget.thirdCardScaleEnd;
  }

  /// Calculates the Y offset for the back card.
  double _calculateBackCardYOffset(double initialOffset, double progress) {
    if (_cardData.length == 2) {
      return initialOffset -
          widget.secondCardOffsetStart +
          widget.secondCardOffsetEnd * progress;
    }
    return initialOffset -
        widget.thirdCardOffsetStart +
        widget.thirdCardOffsetEnd * progress;
  }

  /// Applies the collection animation to the Y offset.
  double _applyCollectionAnimation(double yOffset, int index) {
    return _cardCollectionyOffsetAnimation!
        .drive(CurveTween(curve: Interval((0.4 * (index - 1)), 0.9)))
        .drive(CurveTween(curve: Curves.easeOut))
        .drive(Tween(begin: yOffset, end: yOffset + 20))
        .value;
  }
}

class _CardTransforms {
  final double yOffset;
  final double scale;

  _CardTransforms({required this.yOffset, required this.scale});
}
