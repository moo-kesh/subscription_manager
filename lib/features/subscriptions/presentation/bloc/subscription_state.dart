part of 'subscription_bloc.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.subscriptions = const [],
    this.categories = const [],
    this.activeCategoryFilter,
    this.availableSubscriptions = const [],
  });

  final List<Subscription> subscriptions;
  final List<String> categories;
  final String? activeCategoryFilter;
  final List<Subscription> availableSubscriptions;

  @override
  List<Object?> get props => [
    subscriptions,
    categories,
    activeCategoryFilter,
    availableSubscriptions,
  ];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionsLoading extends SubscriptionState {}

class SubscriptionsLoaded extends SubscriptionState {
  const SubscriptionsLoaded({
    super.subscriptions,
    super.categories,
    super.activeCategoryFilter,
    super.availableSubscriptions,
  });

  @override
  List<Object?> get props => [
    subscriptions,
    categories,
    activeCategoryFilter,
    availableSubscriptions,
  ];

  SubscriptionsLoaded copyWith({
    List<Subscription>? subscriptions,
    List<String>? categories,
    String? activeCategoryFilter,
    List<Subscription>? availableSubscriptions,
  }) {
    return SubscriptionsLoaded(
      subscriptions: subscriptions ?? this.subscriptions,
      categories: categories ?? this.categories,
      activeCategoryFilter: activeCategoryFilter ?? this.activeCategoryFilter,
      availableSubscriptions:
          availableSubscriptions ?? this.availableSubscriptions,
    );
  }
}

class CategoriesLoading extends SubscriptionState {}

class CategoriesLoaded extends SubscriptionState {
  const CategoriesLoaded();

  @override
  List<Object?> get props => [];
}

class SubscriptionOperationSuccess extends SubscriptionState {
  final String? message;
  const SubscriptionOperationSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

class SubscriptionOperationFailure extends SubscriptionState {
  final String error;

  const SubscriptionOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
