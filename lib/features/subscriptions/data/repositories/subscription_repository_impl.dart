import 'package:hive/hive.dart';
import 'package:subscription_manager/features/subscriptions/data/datasources/static_subscription_datasource.dart';
import 'package:subscription_manager/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:subscription_manager/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:uuid/uuid.dart'; // Import Uuid

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final Box<Subscription> subscriptionBox;
  final Box<String> categoryBox;
  final StaticSubscriptionDatasource staticSubscriptionDatasource;
  final Uuid _uuid; // Add Uuid instance

  SubscriptionRepositoryImpl({
    required this.subscriptionBox,
    required this.categoryBox,
    required this.staticSubscriptionDatasource,
  }) : _uuid = const Uuid(); // Initialize Uuid

  @override
  Future<void> addSubscription(Subscription subscription) async {
    // Generate a new unique ID for the subscription before saving
    final newId = _uuid.v4();
    // Ensure the subscription is added to "All Subs" category by default
    final newSubscriptionWithId = subscription.copyWith(
      id: newId,
      category: subscription.category.isEmpty
          ? 'All Subs'
          : subscription.category,
    );
    await subscriptionBox.put(newId, newSubscriptionWithId);
  }

  @override
  Future<List<Subscription>> getSubscriptions() async {
    return subscriptionBox.values.toList();
  }

  @override
  Future<List<Subscription>> getSubscriptionsByCategory(String category) async {
    if (category == 'All Subs') {
      return subscriptionBox.values.toList();
    }
    return subscriptionBox.values
        .where((sub) => sub.category == category)
        .toList();
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    // Ensure the subscription has an ID; if not, it's an error to update.
    // However, our flow should ensure IDs are present for updates.
    if (subscription.id.isEmpty || subscription.id == 'placeholder_id') {
      throw ArgumentError(
        'Subscription ID cannot be empty or placeholder for update.',
      );
    }
    await subscriptionBox.put(subscription.id, subscription);
  }

  @override
  Future<void> deleteSubscription(String id) async {
    await subscriptionBox.delete(id);
  }

  @override
  Future<List<String>> getCategories() async {
    if (categoryBox.isEmpty) {
      final defaultCategories = ['All Subs'];
      for (var category in defaultCategories) {
        if (!categoryBox.containsKey(category)) {
          await categoryBox.put(category, category);
        }
      }
    }
    return categoryBox.values.toList();
  }

  @override
  Future<void> addCategory(String category) async {
    if (!categoryBox.containsKey(category)) {
      await categoryBox.put(category, category);
    }
  }

  @override
  Future<void> deleteCategory(String category) async {
    await categoryBox.delete(category);
    final subscriptionsToUpdate = subscriptionBox.values.where(
      (s) => s.category == category,
    );
    for (var sub in subscriptionsToUpdate) {
      await updateSubscription(sub.copyWith(category: 'Uncategorized'));
    }
  }

  @override
  List<Subscription> getAvailableSubscriptionTemplates() {
    return staticSubscriptionDatasource.getAvailableSubscriptions();
  }
}
