// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faqs_wrapper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqsWrapperData _$FaqsWrapperDataFromJson(Map<String, dynamic> json) =>
    FaqsWrapperData(
      (json['result'] as List<dynamic>)
          .map((e) => FaqData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FaqsWrapperDataToJson(FaqsWrapperData instance) =>
    <String, dynamic>{
      'result': instance.faqs,
    };
