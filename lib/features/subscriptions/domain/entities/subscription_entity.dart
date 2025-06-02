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
  final String category;

  const Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.iconAssetPath,
    required this.cardColorHex,
    required this.category,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    billingCycle,
    iconAssetPath,
    cardColorHex,
    category,
  ];

  Subscription copyWith({
    String? id,
    String? name,
    double? price,
    BillingCycle? billingCycle,
    DateTime? startDate,
    String? iconAssetPath,
    String? cardColorHex,
    String? category,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      iconAssetPath: iconAssetPath ?? this.iconAssetPath,
      cardColorHex: cardColorHex ?? this.cardColorHex,
      category: category ?? this.category,
    );
  }
}
