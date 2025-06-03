import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_manager/core/theme/app_theme.dart';
import 'package:subscription_manager/core/widgets/primary_button.dart';
import 'package:subscription_manager/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:subscription_manager/features/subscriptions/presentation/bloc/subscription_bloc.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet({super.key});

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _categoryNameController = TextEditingController();
  final Set<String> _selectedSubscriptionIds = {};

  @override
  void initState() {
    super.initState();
    _categoryNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        // Get all subscriptions from repository directly, not from filtered state
        return FutureBuilder<List<Subscription>>(
          future: _getAllSubscriptions(context),
          builder: (context, snapshot) {
            final allSubscriptions = snapshot.data ?? [];

            return Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add a category', style: textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _categoryNameController,
                      style: textTheme.bodyLarge?.copyWith(color: kTextColor),
                      decoration: InputDecoration(
                        hintText: 'e.g. Music',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: kTextColor.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: kTextColor.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Select subscriptions', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (allSubscriptions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'No subscriptions available to add to a category yet.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: kTextColor.withValues(alpha: 0.7),
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: allSubscriptions.length,
                          itemBuilder: (context, index) {
                            final subscription = allSubscriptions[index];
                            final isSelected = _selectedSubscriptionIds
                                .contains(subscription.id);
                            return ListTile(
                              leading: Image.asset(
                                subscription.iconAssetPath,
                                width: 32,
                                height: 32,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 32),
                              ),
                              title: Text(
                                subscription.name,
                                style: textTheme.bodyLarge,
                              ),
                              trailing: Checkbox(
                                value: isSelected,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedSubscriptionIds.add(
                                        subscription.id,
                                      );
                                    } else {
                                      _selectedSubscriptionIds.remove(
                                        subscription.id,
                                      );
                                    }
                                  });
                                },
                                activeColor: kPrimaryColor,
                                checkColor: Colors.white,
                              ),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedSubscriptionIds.remove(
                                      subscription.id,
                                    );
                                  } else {
                                    _selectedSubscriptionIds.add(
                                      subscription.id,
                                    );
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      onPressed:
                          _categoryNameController.text.trim().isEmpty ||
                              _selectedSubscriptionIds.isEmpty
                          ? null
                          : () => _handleAddCategory(context, allSubscriptions),
                      text: 'Save',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Subscription>> _getAllSubscriptions(BuildContext context) async {
    final bloc = context.read<SubscriptionBloc>();
    return await bloc.subscriptionRepository.getSubscriptions();
  }

  void _handleAddCategory(
    BuildContext context,
    List<Subscription> allSubscriptions,
  ) {
    final categoryName = _categoryNameController.text.trim();
    if (categoryName.isNotEmpty) {
      context.read<SubscriptionBloc>().add(
        AddCategory(categoryName, _selectedSubscriptionIds.toList()),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }
}
