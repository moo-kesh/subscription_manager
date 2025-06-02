import 'package:subscription_manager/features/subscriptions/domain/entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getSubscriptions();
  Future<List<Subscription>> getSubscriptionsByCategory(String category);
  Future<void> addSubscription(Subscription subscription);
  Future<void> updateSubscription(Subscription subscription);
  Future<void> deleteSubscription(String id);

  Future<List<String>> getCategories();
  Future<void> addCategory(String category);
  Future<void> deleteCategory(String category);
  List<Subscription> getAvailableSubscriptionTemplates();
}
