// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 1;

  @override
  Subscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subscription(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      billingCycle: fields[3] as BillingCycle,
      iconAssetPath: fields[4] as String,
      cardColorHex: fields[5] as String,
      category: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.billingCycle)
      ..writeByte(4)
      ..write(obj.iconAssetPath)
      ..writeByte(5)
      ..write(obj.cardColorHex)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BillingCycleAdapter extends TypeAdapter<BillingCycle> {
  @override
  final int typeId = 0;

  @override
  BillingCycle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BillingCycle.weekly;
      case 1:
        return BillingCycle.monthly;
      case 2:
        return BillingCycle.quarterly;
      case 3:
        return BillingCycle.yearly;
      default:
        return BillingCycle.weekly;
    }
  }

  @override
  void write(BinaryWriter writer, BillingCycle obj) {
    switch (obj) {
      case BillingCycle.weekly:
        writer.writeByte(0);
        break;
      case BillingCycle.monthly:
        writer.writeByte(1);
        break;
      case BillingCycle.quarterly:
        writer.writeByte(2);
        break;
      case BillingCycle.yearly:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingCycleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
