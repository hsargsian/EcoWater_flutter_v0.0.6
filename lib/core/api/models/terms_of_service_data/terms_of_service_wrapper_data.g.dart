// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_of_service_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsOfServiceWrapperData _$TermsOfServiceWrapperDataFromJson(
        Map<String, dynamic> json) =>
    TermsOfServiceWrapperData(
      (json['result'] as List<dynamic>)
          .map((e) => TermsOfServiceData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TermsOfServiceWrapperDataToJson(
        TermsOfServiceWrapperData instance) =>
    <String, dynamic>{
      'result': instance.result,
    };
