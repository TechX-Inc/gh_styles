// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartModelAdapter extends TypeAdapter<CartModel> {
  @override
  final int typeId = 1;

  @override
  CartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartModel(
      productID: fields[1] as String,
      productName: fields[3] as String,
      productDiscount: fields[7] as double,
      productPrice: fields[6] as double,
      productPhotos: (fields[8] as List)?.cast<dynamic>(),
      productSize: fields[5] as String,
      productQuantity: fields[4] as int,
      orderQuantity: fields[0] as int,
      selectionPrice: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CartModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.orderQuantity)
      ..writeByte(1)
      ..write(obj.productID)
      ..writeByte(2)
      ..write(obj.selectionPrice)
      ..writeByte(3)
      ..write(obj.productName)
      ..writeByte(4)
      ..write(obj.productQuantity)
      ..writeByte(5)
      ..write(obj.productSize)
      ..writeByte(6)
      ..write(obj.productPrice)
      ..writeByte(7)
      ..write(obj.productDiscount)
      ..writeByte(8)
      ..write(obj.productPhotos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
