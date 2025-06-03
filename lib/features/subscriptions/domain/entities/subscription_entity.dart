import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'subscription_entity.g.dart';

@HiveType(typeId: 0)
enum BillingCycle {
  @HiveField(0)
  weekly,
  @HiveField(1)
  monthly,
  @HiveField(2)
  quarterly,
  @HiveField(3)
  yearly,
}

@HiveType(typeId: 1)
class Subscription extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final BillingCycle billingCycle;
  @HiveField(4)
  final String iconAssetPath;
  @HiveField(5)
  final String cardColorHex;
  @HiveField(6)
  final List<String> categories;

  const Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.iconAssetPath,
    required this.cardColorHex,
    required this.categories,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    billingCycle,
    iconAssetPath,
    cardColorHex,
    categories,
  ];

  Subscription copyWith({
    String? id,
    String? name,
    double? price,
    BillingCycle? billingCycle,
    DateTime? startDate,
    String? iconAssetPath,
    String? cardColorHex,
    List<String>? categories,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      iconAssetPath: iconAssetPath ?? this.iconAssetPath,
      cardColorHex: cardColorHex ?? this.cardColorHex,
      categories: categories ?? this.categories,
    );
  }
}
