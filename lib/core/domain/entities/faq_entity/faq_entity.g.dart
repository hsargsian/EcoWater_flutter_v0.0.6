// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqEntity _$FaqEntityFromJson(Map<String, dynamic> json) => FaqEntity(
      json['id'] as String,
      json['question'] as String,
      json['answer'] as String,
    );

Map<String, dynamic> _$FaqEntityToJson(FaqEntity instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
    };
