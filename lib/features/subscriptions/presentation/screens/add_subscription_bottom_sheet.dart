import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_manager/core/theme/app_theme.dart';
import 'package:subscription_manager/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:subscription_manager/features/subscriptions/presentation/bloc/subscription_bloc.dart';

class AddSubscriptionBottomSheet extends StatefulWidget {
  const AddSubscriptionBottomSheet({super.key});

  @override
  State<AddSubscriptionBottomSheet> createState() =>
      _AddSubscriptionBottomSheetState();
}

class _AddSubscriptionBottomSheetState
    extends State<AddSubscriptionBottomSheet> {
  @override
  void initState() {
    super.initState();
    // Load available subscriptions when the bottom sheet opens
    context.read<SubscriptionBloc>().add(LoadAvailableSubscriptions());
  }

  Set<Subscription> _getAddedSubscriptionNames(SubscriptionState state) {
    if (state is SubscriptionsLoaded) {
      return state.subscriptions
          .where((sub) => state.activeCategoryFilter == sub.category)
          .toSet();
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Subscription',
                  style: textTheme.headlineSmall?.copyWith(color: kTextColor),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: kTextColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
                builder: (context, state) {
                  final availableSubscriptions = state.availableSubscriptions;
                  final addedSubscriptions = _getAddedSubscriptionNames(state);

                  if (availableSubscriptions.isEmpty) {
                    return const Center(
                      child: Text(
                        'No subscription templates available',
                        style: TextStyle(color: kTextColor),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: availableSubscriptions.length,
                    itemBuilder: (context, index) {
                      final subTemplate = availableSubscriptions[index];
                      final isAdded = addedSubscriptions.any(
                        (sub) => sub.name == subTemplate.name,
                      );

                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            subTemplate.iconAssetPath,
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 40),
                          ),
                          title: Text(
                            subTemplate.name,
                            style: textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            '\$${subTemplate.price.toStringAsFixed(2)} / ${subTemplate.billingCycle.name}',
                            style: textTheme.bodyMedium,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isAdded
                                  ? Icons.remove_circle
                                  : Icons.add_circle_outline,
                              color: isAdded ? Colors.red : kPrimaryColor,
                              size: 28,
                            ),
                            onPressed: () {
                              if (isAdded) {
                                // Find the actual subscription in the user's list and remove it
                                final subscriptionToRemove = state.subscriptions
                                    .firstWhere(
                                      (sub) => sub.name == subTemplate.name,
                                      orElse: () => throw Exception(
                                        'Subscription not found',
                                      ),
                                    );
                                context.read<SubscriptionBloc>().add(
                                  RemoveSubscription(subscriptionToRemove.id),
                                );
                              } else {
                                // Add the subscription with current date
                                context.read<SubscriptionBloc>().add(
                                  AddSubscription(
                                    subTemplate.copyWith(
                                      category:
                                          state.activeCategoryFilter ??
                                          'All Subs',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
