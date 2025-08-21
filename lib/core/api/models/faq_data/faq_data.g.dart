// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqData _$FaqDataFromJson(Map<String, dynamic> json) => FaqData(
      json['_id'] as String,
      json['title'] as String,
      json['body'] as String,
    );

Map<String, dynamic> _$FaqDataToJson(FaqData instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'body': instance.body,
    };
