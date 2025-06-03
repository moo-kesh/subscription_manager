import 'package:hive/hive.dart';
import 'package:subscription_manager/features/subscriptions/data/datasources/static_subscription_datasource.dart';
import 'package:subscription_manager/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:subscription_manager/features/subscriptions/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final Box<Subscription> subscriptionBox;
  final Box<String> categoryBox;
  final StaticSubscriptionDatasource staticSubscriptionDatasource;

  SubscriptionRepositoryImpl({
    required this.subscriptionBox,
    required this.categoryBox,
    required this.staticSubscriptionDatasource,
  });

  @override
  Future<void> addSubscription(Subscription subscription) async {
    // For new user subscriptions, generate a unique ID if none exists
    final subscriptionToAdd = subscription.id.isEmpty
        ? subscription.copyWith(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
          )
        : subscription;

    await subscriptionBox.put(subscriptionToAdd.id, subscriptionToAdd);
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
        .where((sub) => sub.categories.contains(category))
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
      (s) => s.categories.contains(category),
    );
    for (var sub in subscriptionsToUpdate) {
      final newCategories = sub.categories
          .where((cat) => cat != category)
          .toList();
      if (newCategories.isEmpty) {
        newCategories.add('All Subs');
      }
      await updateSubscription(sub.copyWith(categories: newCategories));
    }
  }

  @override
  Future<void> addCategoryToSubscription(
    String subscriptionId,
    String category,
  ) async {
    final subscription = subscriptionBox.get(subscriptionId);
    if (subscription != null) {
      final newCategories = Set<String>.from(subscription.categories);
      newCategories.add(category);
      await updateSubscription(
        subscription.copyWith(categories: newCategories.toList()),
      );
    }
  }

  @override
  List<Subscription> getAvailableSubscriptionTemplates() {
    return staticSubscriptionDatasource.getAvailableSubscriptions();
  }

  @override
  Future<void> initializeDefaultData() async {
    // This method is called only on first app launch
    // Clear any existing data (in case of corrupted state)
    await subscriptionBox.clear();
    await categoryBox.clear();

    // Add default categories
    const defaultCategories = ['All Subs', 'Entertainment'];
    for (var category in defaultCategories) {
      await addCategory(category);
    }

    // Add static subscriptions to database
    final staticSubscriptions = staticSubscriptionDatasource
        .getAvailableSubscriptions();
    for (var subscription in staticSubscriptions) {
      await subscriptionBox.put(subscription.id, subscription);
    }
  }
}
