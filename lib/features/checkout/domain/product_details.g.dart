// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductDetailsImpl _$$ProductDetailsImplFromJson(Map<String, dynamic> json) =>
    _$ProductDetailsImpl(
      produt_id: json['produt_id'] as String,
      quantity: json['qty'] as String,
      price: json['price'] as String,
      title: json['title'] as String,
      vendor: json['vendor'] as String,
      image_url: json['image_url'] as String,
      location_id: json['location_id'] as String,
      inventory_item_id: json['inventory_item_id'] as String,
    );

Map<String, dynamic> _$$ProductDetailsImplToJson(
        _$ProductDetailsImpl instance) =>
    <String, dynamic>{
      'produt_id': instance.produt_id,
      'qty': instance.quantity,
      'price': instance.price,
      'title': instance.title,
      'vendor': instance.vendor,
      'image_url': instance.image_url,
      'location_id': instance.location_id,
      'inventory_item_id': instance.inventory_item_id,
    };
