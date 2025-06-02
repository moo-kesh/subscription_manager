import 'package:flutter/material.dart';

/// A carousel widget that displays items with an overlapping effect.
///
/// The carousel supports infinite scrolling, customizable skew angles,
/// and animations for scaling and spreading items.
class OverlappedCarousel extends StatefulWidget {
  /// The list of widgets to display in the carousel.
  final List<Widget> widgets;

  /// Callback function invoked when a card is clicked.
  /// Provides the index of the clicked card.
  final Function(int)? onClicked;

  /// The initial index of the card to be centered.
  /// If null, defaults to the middle of the `widgets` list.
  final int? currentIndex;

  /// Callback function invoked when the centered card index changes.
  final ValueChanged<int>? onIndexChanged;

  /// Determines if swiping can scroll through multiple items at once (true)
  /// or only one item per swipe gesture (false).
  final bool freeScroll;

  /// The skew angle applied to the cards, creating a 3D effect.
  final double skewAngle;

  const OverlappedCarousel({
    super.key,
    required this.widgets,
    this.onClicked,
    this.currentIndex,
    this.onIndexChanged,
    this.freeScroll = true,
    this.skewAngle = -0.25,
  });

  @override
  OverlappedCarouselState createState() => OverlappedCarouselState();
}

class OverlappedCarouselState extends State<OverlappedCarousel>
    with TickerProviderStateMixin {
  /// The current (potentially fractional) index of the centered card.
  /// This value is used for smooth animation and gesture handling.
  double currentIndex = 2;

  /// Stores the index at the start of a drag gesture.
  /// Used for single-item swipe calculations when `freeScroll` is false.
  late double _dragStartIndex;

  /// Tracks the horizontal drag offset during a pan gesture.
  double _dragOffset = 0.0;

  /// The last actual index reported to `widget.onIndexChanged`.
  /// Used to prevent redundant callback invocations.
  int _lastReportedActualIndex = -1;

  /// Controller for the initial scaling animation of the entire carousel.
  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAnimation;

  /// Controller for the animation that spreads the cards out.
  late AnimationController _spreadAnimationController;
  late Animation<double> _spreadAnimation;

  /// The list of widget items managed by the carousel.
  /// This list is rotated to achieve an infinite scrolling effect.
  late List<Widget> items;

  @override
  void initState() {
    super.initState();

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.easeOut),
    );

    _spreadAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _spreadAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _spreadAnimationController,
        curve: Curves.easeOut,
      ),
    );

    items = List.from(widget.widgets);
    final int n = items.length;
    // Initialize currentIndex to allow for "infinite" scrolling by starting in a "middle" cycle.
    currentIndex = (widget.currentIndex ?? (n > 0 ? n ~/ 2 : 0)).toDouble() + n;
    _reportIndexChanged();

    // Start scale animation, then chain spread animation.
    _scaleAnimationController.forward().then((_) {
      _spreadAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _spreadAnimationController.dispose();
    super.dispose();
  }

  /// Reports the change in the current actual index to the `onIndexChanged` callback.
  ///
  /// This method ensures the callback is only invoked when the actual index
  /// (modulo the number of widgets) changes.
  void _reportIndexChanged() {
    if (widget.onIndexChanged == null || widget.widgets.isEmpty) {
      return;
    }
    final int n = widget.widgets.length;
    int actualIndex = currentIndex.round() % n;

    if (_lastReportedActualIndex != actualIndex) {
      widget.onIndexChanged!(actualIndex);
      _lastReportedActualIndex = actualIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _spreadAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value, // Apply initial scale-up animation
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onPanStart: (details) {
                    _dragStartIndex =
                        currentIndex; // Record index at drag start
                    _dragOffset = 0.0;
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      final int n = widget.widgets.length;
                      if (n == 0) return; // No items to scroll

                      if (widget.freeScroll) {
                        // Continuous scrolling based on drag delta
                        currentIndex = currentIndex - details.delta.dx * 0.02;
                      } else {
                        // Single-item scrolling: track offset and clamp to one item
                        _dragOffset += details.delta.dx;
                        double deltaIndex = (_dragOffset * 0.02).clamp(
                          -1.0,
                          1.0,
                        );
                        currentIndex = _dragStartIndex - deltaIndex;
                      }

                      // Handle infinite wrap by rotating items in the `items` list
                      if (currentIndex < n && n > 0) {
                        // Scrolled past start: move first item to end
                        items.add(items.removeAt(0));
                        currentIndex +=
                            n; // Adjust index to reflect the rotation
                      } else if (currentIndex >= n * 2 && n > 0) {
                        // Scrolled past end: move last item to start
                        items.insert(0, items.removeLast());
                        currentIndex -=
                            n; // Adjust index to reflect the rotation
                      }
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      final int n = widget.widgets.length;
                      if (n == 0) return;

                      if (widget.freeScroll) {
                        currentIndex = currentIndex
                            .ceil()
                            .toDouble(); // Snap to nearest item
                      } else {
                        // Finalize single-item scroll based on drag direction
                        double totalIndexDelta = (_dragOffset * 0.02);
                        if (totalIndexDelta > 0) {
                          // Dragged right
                          currentIndex = (_dragStartIndex - 1).toDouble();
                        } else if (totalIndexDelta < 0) {
                          // Dragged left
                          currentIndex = (_dragStartIndex + 1).toDouble();
                        } else {
                          // No significant drag
                          currentIndex = _dragStartIndex;
                        }
                      }

                      // Handle infinite wrap after snapping/finalizing scroll
                      if (currentIndex < n && n > 0) {
                        items.add(items.removeAt(0));
                        currentIndex += n;
                      } else if (currentIndex >= n * 2 && n > 0) {
                        items.insert(0, items.removeLast());
                        currentIndex -= n;
                      }
                      _reportIndexChanged(); // Report final index
                    });
                  },
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(end: currentIndex),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    builder: (context, animatedIndex, child) {
                      return OverlappedCarouselCardItems(
                        // Generate a tripled list of cards to simulate infinite scrolling.
                        // The actual items are taken from the `items` list, modulo its length.
                        cards: List.generate(
                          items.length *
                              3, // Triple the items for smooth wrapping
                          (index) => CardModel(
                            id: index,
                            child: items[index % items.length],
                          ),
                        ),
                        centerIndex:
                            animatedIndex, // Use animated index for smooth transitions
                        maxWidth: constraints.maxWidth,
                        maxHeight: constraints.maxHeight,
                        onClicked: widget.onClicked ?? (index) {},
                        skewAngle: widget.skewAngle,
                        spreadAnimation: _spreadAnimation
                            .value, // Apply card spread animation
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// A widget that lays out the individual cards in the [OverlappedCarousel].
///
/// It handles the positioning, sizing, transformation, and stacking of cards
/// based on the `centerIndex` and `spreadAnimation`.
class OverlappedCarouselCardItems extends StatelessWidget {
  /// The list of [CardModel] objects to display.
  final List<CardModel> cards;

  /// Callback function invoked when a card is clicked.
  final Function(int) onClicked;

  /// The current (potentially fractional) index of the centered card.
  final double centerIndex;

  /// The maximum height available for the carousel items.
  final double maxHeight;

  /// The maximum width available for the carousel items.
  final double maxWidth;

  /// The skew angle for the cards.
  final double skewAngle;

  /// The current value of the spread animation (0.0 to 1.0).
  /// 0.0 means cards are stacked at the center, 1.0 means they are spread out.
  final double spreadAnimation;

  const OverlappedCarouselCardItems({
    super.key,
    required this.cards,
    required this.centerIndex,
    required this.maxHeight,
    required this.maxWidth,
    required this.onClicked,
    required this.skewAngle,
    required this.spreadAnimation,
  });

  /// Calculates the horizontal position of a card.
  ///
  /// The position is determined by the card's distance from the `centerIndex`
  /// and interpolated based on the `spreadAnimation` value.
  double getCardPosition(int index) {
    final double center = maxWidth / 2;
    final double centerWidgetWidth = maxWidth / 4;
    final double basePosition = center - centerWidgetWidth / 2 - 12;
    final double distance = centerIndex - index;

    final double nearWidgetWidth = centerWidgetWidth / 5 * 4;
    final double farWidgetWidth = centerWidgetWidth / 5 * 3;

    // Calculate the target position when fully spread out
    double finalPosition;
    if (distance == 0) {
      // Center card
      finalPosition = basePosition;
    } else if (distance.abs() > 0.0 && distance.abs() <= 1.0) {
      // Cards immediately next to center
      if (distance > 0) {
        finalPosition = basePosition - nearWidgetWidth * distance.abs();
      } else {
        finalPosition = basePosition + centerWidgetWidth * distance.abs();
      }
    } else if (distance.abs() >= 1.0 && distance.abs() <= 2.0) {
      // Cards further from center
      if (distance > 0) {
        finalPosition =
            (basePosition - nearWidgetWidth) -
            farWidgetWidth * (distance.abs() - 1);
      } else {
        finalPosition =
            (basePosition + centerWidgetWidth + nearWidgetWidth) +
            farWidgetWidth * (distance.abs() - 2) -
            (nearWidgetWidth - farWidgetWidth) *
                ((distance - distance.floor()));
      }
    } else {
      // Cards beyond the visible range (positioned off-screen)
      if (distance > 0) {
        finalPosition =
            (basePosition - nearWidgetWidth) -
            farWidgetWidth * (distance.abs() - 1);
      } else {
        finalPosition =
            (basePosition + centerWidgetWidth + nearWidgetWidth) +
            farWidgetWidth * (distance.abs() - 2);
      }
    }

    // Interpolate position from a central point to its final spread-out position
    // based on the spreadAnimation value.
    final double centerStartPosition =
        basePosition; // All items initially appear from the center
    return centerStartPosition +
        (finalPosition - centerStartPosition) * spreadAnimation;
  }

  /// Calculates the width of a card based on its distance from the `centerIndex`.
  /// Cards closer to the center are wider.
  double getCardWidth(int index) {
    final double distance = (centerIndex - index).abs();
    final double centerWidgetWidth = maxWidth / 3.5;
    final double nearWidgetWidth = centerWidgetWidth / 5 * 4.5;
    final double farWidgetWidth = centerWidgetWidth / 5 * 3.5;

    if (distance >= 0.0 && distance < 1.0) {
      // Center or partially transitioning from center
      return centerWidgetWidth -
          (centerWidgetWidth - nearWidgetWidth) * (distance - distance.floor());
    } else if (distance >= 1.0 && distance < 2.0) {
      // Next to center or partially transitioning
      return nearWidgetWidth -
          (nearWidgetWidth - farWidgetWidth) * (distance - distance.floor());
    } else {
      // Furthest visible cards
      return farWidgetWidth;
    }
  }

  /// Calculates the `Matrix4` transformation for a card.
  /// Applies skew based on distance from center and a slight scale effect.
  Matrix4 getTransform(int index) {
    final double distance = centerIndex - index;

    var transform = Matrix4.identity()
      ..setEntry(3, 2, 0.007) // Perspective effect
      ..rotateY(skewAngle * distance) // Skew based on distance
      ..scale(1.15, 1.15, 1.15); // Base scale for non-centered items
    if (index == centerIndex.round()) {
      transform.scale(
        1.05,
        1.05,
        1.05,
      ); // Slightly larger scale for the centered item
    }
    return transform;
  }

  /// Builds a single card item widget.
  ///
  /// Applies opacity, size, and clipping to the card's child widget.
  Widget _buildItem(CardModel item) {
    final int index = item.id;
    final double distance = (centerIndex - index).abs();
    // Furthest visible items (distance == 2) get reduced opacity.
    final double itemOpacity = (distance >= 1.5 && distance <= 2.5) ? 0.8 : 1.0;
    final double size = getCardWidth(index);
    final double position = getCardPosition(index);

    return Positioned(
      left: position,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Match the ClipOval shape
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: itemOpacity,
          child: SizedBox(
            width: size,
            height: size, // Use square sizing for circular clipping
            child: ClipOval(
              child: SizedBox(width: size, height: size, child: item.child),
            ),
          ),
        ),
      ),
    );
  }

  /// Sorts widgets by z-index to ensure correct stacking order and filters visible items.
  ///
  /// Only the center card and two cards on each side are typically rendered.
  List<Widget> _sortedStackWidgets(List<CardModel> widgets) {
    // Assign z-index for correct stacking: center item is highest.
    for (int i = 0; i < widgets.length; i++) {
      if (widgets[i].id == centerIndex.round()) {
        widgets[i].zIndex = widgets.length.toDouble();
      } else if (widgets[i].id < centerIndex) {
        widgets[i].zIndex = widgets[i].id.toDouble();
      } else {
        widgets[i].zIndex =
            widgets.length.toDouble() - widgets[i].id.toDouble();
      }
    }
    // Sort by z-index.
    widgets.sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return widgets.map((e) {
      // Display only the center card and two cards on each side (5 total).
      final double distance = (centerIndex - e.id).abs();
      if (distance >= 0 && distance <= 2.5) {
        // Render items within a certain distance from center
        return _buildItem(e);
      } else {
        return Container(); // Off-screen items are empty containers
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        clipBehavior: Clip.none, // Allow items to overflow for visual effect
        children: _sortedStackWidgets(cards),
      ),
    );
  }
}

/// Represents a card in the [OverlappedCarousel].
class CardModel {
  /// The unique identifier for the card, typically its index in the source list.
  final int id;

  /// The z-index of the card, used for determining stacking order in the `Stack`.
  double zIndex;

  /// The widget content to display within the card.
  final Widget? child;

  CardModel({required this.id, this.zIndex = 0.0, this.child});
}
