part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubscriptions extends SubscriptionEvent {}

class LoadAvailableSubscriptions extends SubscriptionEvent {}

class AddSubscription extends SubscriptionEvent {
  final Subscription subscription;

  const AddSubscription(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class AddCategory extends SubscriptionEvent {
  final String categoryName;
  final List<String>
  subscriptionIds; // IDs of subscriptions to associate with this category

  const AddCategory(this.categoryName, this.subscriptionIds);

  @override
  List<Object?> get props => [categoryName, subscriptionIds];
}

class RemoveSubscription extends SubscriptionEvent {
  final String subscriptionId;

  const RemoveSubscription(this.subscriptionId);

  @override
  List<Object?> get props => [subscriptionId];
}

class FilterSubscriptionsByCategory extends SubscriptionEvent {
  final String? categoryName;

  const FilterSubscriptionsByCategory(this.categoryName);

  @override
  List<Object?> get props => [categoryName];
}
