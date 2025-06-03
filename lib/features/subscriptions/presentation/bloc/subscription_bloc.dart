import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_manager/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:subscription_manager/features/subscriptions/domain/repositories/subscription_repository.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository subscriptionRepository;

  SubscriptionBloc({required this.subscriptionRepository})
    : super(SubscriptionInitial()) {
    on<LoadSubscriptions>(_onLoadSubscriptions);
    on<LoadAvailableSubscriptions>(_onLoadAvailableSubscriptions);
    on<AddSubscription>(_onAddSubscription);
    on<RemoveSubscription>(_onRemoveSubscription);
    on<AddCategory>(_onAddCategory);
    on<FilterSubscriptionsByCategory>(_onFilterSubscriptionsByCategory);
  }

  Future<void> _onLoadSubscriptions(
    LoadSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionsLoading());
    try {
      final subscriptions = await subscriptionRepository.getSubscriptions();
      final categories = await subscriptionRepository.getCategories();
      final availableSubscriptions = subscriptionRepository
          .getAvailableSubscriptionTemplates();
      emit(
        SubscriptionsLoaded(
          subscriptions: subscriptions,
          categories: categories,
          availableSubscriptions: availableSubscriptions,
          activeCategoryFilter: categories.isNotEmpty ? categories.first : null,
        ),
      );
    } catch (e) {
      emit(SubscriptionOperationFailure(e.toString()));
    }
  }

  Future<void> _onLoadAvailableSubscriptions(
    LoadAvailableSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      final availableSubscriptions = subscriptionRepository
          .getAvailableSubscriptionTemplates();

      if (state is SubscriptionsLoaded) {
        final currentState = state as SubscriptionsLoaded;
        emit(
          currentState.copyWith(availableSubscriptions: availableSubscriptions),
        );
      } else {
        // If no subscriptions loaded yet, just emit with available subscriptions
        emit(
          SubscriptionsLoaded(availableSubscriptions: availableSubscriptions),
        );
      }
    } catch (e) {
      emit(SubscriptionOperationFailure(e.toString()));
    }
  }

  Future<void> _onAddSubscription(
    AddSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      await subscriptionRepository.addSubscription(event.subscription);
      final subscriptions = await subscriptionRepository.getSubscriptions();
      final categories = await subscriptionRepository.getCategories();
      final availableSubscriptions = subscriptionRepository
          .getAvailableSubscriptionTemplates();
      String? currentFilter = state is SubscriptionsLoaded
          ? (state as SubscriptionsLoaded).activeCategoryFilter
          : null;
      if (categories.isNotEmpty &&
          (currentFilter == null || !categories.contains(currentFilter))) {
        currentFilter = categories.first;
      }
      emit(
        SubscriptionsLoaded(
          subscriptions: subscriptions,
          categories: categories,
          availableSubscriptions: availableSubscriptions,
          activeCategoryFilter: currentFilter,
        ),
      );
    } catch (e) {
      emit(SubscriptionOperationFailure(e.toString()));
    }
  }

  Future<void> _onRemoveSubscription(
    RemoveSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      await subscriptionRepository.deleteSubscription(event.subscriptionId);
      final subscriptions = await subscriptionRepository.getSubscriptions();
      final categories = await subscriptionRepository.getCategories();
      final availableSubscriptions = subscriptionRepository
          .getAvailableSubscriptionTemplates();
      String? currentFilter = state is SubscriptionsLoaded
          ? (state as SubscriptionsLoaded).activeCategoryFilter
          : null;
      if (categories.isNotEmpty &&
          (currentFilter == null || !categories.contains(currentFilter))) {
        currentFilter = categories.first;
      }
      emit(
        SubscriptionsLoaded(
          subscriptions: subscriptions,
          categories: categories,
          availableSubscriptions: availableSubscriptions,
          activeCategoryFilter: currentFilter,
        ),
      );
    } catch (e) {
      emit(SubscriptionOperationFailure(e.toString()));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      await subscriptionRepository.addCategory(event.categoryName);
      for (String subId in event.subscriptionIds) {
        final List<Subscription> currentSubscriptions =
            await subscriptionRepository.getSubscriptions();
        final subToUpdate = currentSubscriptions.firstWhere(
          (s) => s.id == subId,
          orElse: () => throw Exception('Subscription not found'),
        );
        await subscriptionRepository.updateSubscription(
          subToUpdate.copyWith(category: event.categoryName),
        );
      }
      final subscriptions = await subscriptionRepository.getSubscriptions();
      final categories = await subscriptionRepository.getCategories();
      final availableSubscriptions = subscriptionRepository
          .getAvailableSubscriptionTemplates();
      emit(
        SubscriptionsLoaded(
          subscriptions: subscriptions,
          categories: categories,
          availableSubscriptions: availableSubscriptions,
          activeCategoryFilter: event.categoryName,
        ),
      );
    } catch (e) {
      emit(SubscriptionOperationFailure(e.toString()));
    }
  }

  Future<void> _onFilterSubscriptionsByCategory(
    FilterSubscriptionsByCategory event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      final currentState = state as SubscriptionsLoaded;
      List<Subscription> filteredSubscriptions;

      if (event.categoryName == null || event.categoryName == 'All Subs') {
        filteredSubscriptions = await subscriptionRepository.getSubscriptions();
      } else {
        filteredSubscriptions = await subscriptionRepository
            .getSubscriptionsByCategory(event.categoryName!);
      }

      emit(
        currentState.copyWith(
          subscriptions: filteredSubscriptions,
          activeCategoryFilter: event.categoryName ?? 'All Subs',
        ),
      );
    } catch (e) {
      emit(SubscriptionOperationFailure(e.toString()));
    }
  }
}
