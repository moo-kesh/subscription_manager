import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:subscription_manager/core/animations/scale_animation.dart';
import 'package:subscription_manager/core/theme/app_theme.dart';
import 'package:subscription_manager/core/utils/color_utils.dart';
import 'package:subscription_manager/core/widgets/custom_filter_chip.dart';
import 'package:subscription_manager/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:subscription_manager/features/subscriptions/presentation/bloc/subscription_bloc.dart';
import 'package:subscription_manager/features/subscriptions/presentation/screens/add_category_bottom_sheet.dart';
import 'package:subscription_manager/features/subscriptions/presentation/screens/add_subscription_bottom_sheet.dart';

class MySubsScreen extends StatefulWidget {
  const MySubsScreen({super.key});

  @override
  State<MySubsScreen> createState() => _MySubsScreenState();
}

class _MySubsScreenState extends State<MySubsScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Subscription> _currentFilteredSubscriptions = [];
  bool _isInitialLoad = true;
  String? _lastCategoryFilter;

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>().add(LoadSubscriptions());
  }

  void _showAddCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<SubscriptionBloc>(context),
        child: const AddCategoryBottomSheet(),
      ),
    );
  }

  void _showAddSubscriptionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<SubscriptionBloc>(context),
        child: const AddSubscriptionBottomSheet(),
      ),
    );
  }

  void _updateFilteredList(
    List<Subscription> newFilteredSubscriptions,
    String? categoryFilter,
  ) {
    final oldLength = _currentFilteredSubscriptions.length;
    final newLength = newFilteredSubscriptions.length;

    // Check if this is a category change (which should trigger fresh animation)
    final isCategoryChange = _lastCategoryFilter != categoryFilter;
    _lastCategoryFilter = categoryFilter;

    if (_isInitialLoad || isCategoryChange) {
      // For initial load or category changes, clear and rebuild with animation
      _isInitialLoad = false;

      // Clear the current list without animation
      if (oldLength > 0) {
        for (int i = oldLength - 1; i >= 0; i--) {
          _listKey.currentState?.removeItem(
            i + 1, // +1 for Add subscription card
            (context, animation) => const SizedBox.shrink(),
            duration: Duration.zero,
          );
        }
      }

      // Update the internal list
      _currentFilteredSubscriptions = List.from(newFilteredSubscriptions);

      // Add new items with staggered animation
      for (int i = 0; i < newLength; i++) {
        Future.delayed(Duration(milliseconds: i * 100), () {
          if (mounted) {
            _listKey.currentState?.insertItem(
              i + 1,
            ); // +1 for Add subscription card
          }
        });
      }
    } else {
      // Handle add/remove operations within the same category
      _handleItemChanges(newFilteredSubscriptions, oldLength, newLength);
    }
  }

  void _handleItemChanges(
    List<Subscription> newFilteredSubscriptions,
    int oldLength,
    int newLength,
  ) {
    if (newLength < oldLength) {
      // Items were removed - find which ones and animate them out
      final itemsToRemove = oldLength - newLength;
      for (int i = 0; i < itemsToRemove; i++) {
        final indexToRemove = oldLength - 1 - i;
        if (indexToRemove < _currentFilteredSubscriptions.length) {
          final removedItem = _currentFilteredSubscriptions[indexToRemove];
          _currentFilteredSubscriptions.removeAt(indexToRemove);

          _listKey.currentState?.removeItem(
            indexToRemove + 1, // +1 for Add subscription card
            (context, animation) => SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0), // Slide to left
                ),
              ),
              child: _buildSubscriptionCard(
                context,
                removedItem,
                Theme.of(context).textTheme,
                indexToRemove * 80.0,
              ),
            ),
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    } else if (newLength > oldLength) {
      // Items were added - animate them in
      final itemsToAdd = newLength - oldLength;
      for (int i = 0; i < itemsToAdd; i++) {
        final indexToAdd = oldLength + i;
        if (indexToAdd < newFilteredSubscriptions.length) {
          _currentFilteredSubscriptions.add(
            newFilteredSubscriptions[indexToAdd],
          );

          _listKey.currentState?.insertItem(
            indexToAdd + 1, // +1 for Add subscription card
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    }

    // Ensure the list is properly synchronized
    if (_currentFilteredSubscriptions.length !=
        newFilteredSubscriptions.length) {
      _currentFilteredSubscriptions = List.from(newFilteredSubscriptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionOperationFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
          } else if (state is SubscriptionOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Operation successful')),
            );
            // Reload subscriptions after successful operation to trigger animation
            context.read<SubscriptionBloc>().add(LoadSubscriptions());
          }
        },
        buildWhen: (previous, current) =>
            current is SubscriptionInitial ||
            current is SubscriptionsLoading ||
            current is SubscriptionsLoaded ||
            current is CategoriesLoaded,
        builder: (context, state) {
          if (state is SubscriptionsLoading || state is SubscriptionInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SubscriptionsLoaded) {
            final filteredSubscriptions =
                state.activeCategoryFilter == 'All subs' ||
                    state.activeCategoryFilter == null
                ? state.subscriptions
                : state.subscriptions
                      .where(
                        (sub) => sub.category == state.activeCategoryFilter,
                      )
                      .toList();

            // Update the animated list when filter changes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateFilteredList(
                filteredSubscriptions,
                state.activeCategoryFilter,
              );
            });

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.categories.length) {
                            return ScaleAnimationWidget(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: kSurfaceColor,
                                ),
                                onPressed: () {
                                  _showAddCategoryBottomSheet(context);
                                },
                              ),
                            );
                          }
                          final category = state.categories[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CustomFilterChip(
                              label: category,
                              isSelected:
                                  state.activeCategoryFilter == category,
                              onSelected: (selected) {
                                if (selected) {
                                  context.read<SubscriptionBloc>().add(
                                    FilterSubscriptionsByCategory(category),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedList(
                      shrinkWrap: true,
                      key: _listKey,
                      initialItemCount:
                          1, // Always start with just the Add subscription card
                      itemBuilder: (context, index, animation) {
                        if (index == 0) {
                          return SlideTransition(
                            position: animation.drive(
                              Tween<Offset>(
                                begin: const Offset(
                                  1.0,
                                  0.0,
                                ), // Slide from right
                                end: Offset.zero,
                              ),
                            ),
                            child: _buildAddSubscriptionCard(
                              context,
                              textTheme,
                            ),
                          );
                        }

                        final subscriptionIndex = index - 1;
                        if (subscriptionIndex <
                            _currentFilteredSubscriptions.length) {
                          final subscription =
                              _currentFilteredSubscriptions[subscriptionIndex];
                          return SlideTransition(
                            position: animation.drive(
                              Tween<Offset>(
                                begin: const Offset(
                                  1.0,
                                  0.0,
                                ), // Slide from right
                                end: Offset.zero,
                              ),
                            ),
                            child: _buildSubscriptionCard(
                              context,
                              subscription,
                              textTheme,
                              index * 80.0,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }

  Widget _buildAddSubscriptionCard(BuildContext context, TextTheme textTheme) {
    return Container(
      height: 160.0,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add a subscription',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    _showAddSubscriptionBottomSheet(context);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        CupertinoIcons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(
    BuildContext context,
    Subscription subscription,
    TextTheme textTheme,
    double offset,
  ) {
    Color cardColor = hexToColor(subscription.cardColorHex);

    return Transform.translate(
      offset: Offset(0, -offset),
      child: Container(
        height: 160.0,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '\$ ${subscription.price.toStringAsFixed(2)} / ${subscription.billingCycle.name}',
                          style: GoogleFonts.redHatDisplay(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                backgroundColor: kTextColor,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    subscription.iconAssetPath,
                    width: 48,
                    height: 48,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
