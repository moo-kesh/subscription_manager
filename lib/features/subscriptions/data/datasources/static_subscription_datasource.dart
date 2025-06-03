import 'package:subscription_manager/features/subscriptions/domain/entities/subscription_entity.dart';

class StaticSubscriptionDatasource {
  static final List<Subscription> _availableSubscriptions = [
    Subscription(
      id: 'netflix',
      name: 'Netflix',
      price: 15.49,
      billingCycle: BillingCycle.monthly,
      iconAssetPath: 'assets/icons/ic_netflix.png',
      cardColorHex: 'E50914',
      categories: ['All Subs', 'Entertainment'],
    ),
    Subscription(
      id: 'github_pro',
      name: 'GitHub Pro',
      price: 4.0,
      billingCycle: BillingCycle.monthly,
      iconAssetPath: 'assets/icons/ic_github.png',
      cardColorHex: '181717',
      categories: ['All Subs'],
    ),
    Subscription(
      id: 'spotify',
      name: 'Spotify Premium',
      price: 9.99,
      billingCycle: BillingCycle.monthly,
      iconAssetPath: 'assets/icons/ic_spotify.png',
      cardColorHex: '1DB954',
      categories: ['All Subs', 'Entertainment'],
    ),
    Subscription(
      id: 'youtube_premium',
      name: 'YouTube Premium',
      price: 11.99,
      billingCycle: BillingCycle.monthly,
      iconAssetPath: 'assets/icons/ic_youtube.png',
      cardColorHex: 'FF0000',
      categories: ['All Subs', 'Entertainment'],
    ),
    Subscription(
      id: 'figma',
      name: 'Figma Standard',
      price: 12.0,
      billingCycle: BillingCycle.monthly,
      iconAssetPath: 'assets/icons/ic_figma.png',
      cardColorHex: 'A259FF',
      categories: ['All Subs'],
    ),
    Subscription(
      id: 'apple_music',
      name: 'Apple Music',
      price: 10.99,
      billingCycle: BillingCycle.monthly,
      iconAssetPath: 'assets/icons/ic_apple.png',
      cardColorHex: '000000',
      categories: ['All Subs', 'Entertainment'],
    ),
    Subscription(
      id: 'amazon_prime',
      name: 'Amazon Prime',
      price: 14.99,
      billingCycle: BillingCycle.monthly,
      iconAssetPath: 'assets/icons/ic_amazon.png',
      cardColorHex: '00A8E1',
      categories: ['All Subs', 'Entertainment'],
    ),
    Subscription(
      id: 'hbo_max',
      name: 'HBO Max',
      price: 15.99,
      billingCycle: BillingCycle.monthly,
      iconAssetPath: 'assets/icons/ic_hbo.png',
      cardColorHex: '672C8B',
      categories: ['All Subs', 'Entertainment'],
    ),
  ];

  List<Subscription> getAvailableSubscriptions() {
    return _availableSubscriptions;
  }

  Subscription? getSubscriptionTemplate(String name) {
    try {
      return _availableSubscriptions.firstWhere((sub) => sub.name == name);
    } catch (e) {
      return null;
    }
  }
}
