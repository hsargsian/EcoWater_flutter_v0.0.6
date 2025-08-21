import 'dart:math';

import 'package:echowater/core/api/models/protocol_wrapper_data/protocol_data.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/protocol_wrapper_entity/protocol_wrapper_entity.dart';
import '../page_meta_data/page_meta_data.dart';

part 'protocol_wrapper_data.g.dart';

@JsonSerializable()
class ProtocolWrapperData {
  ProtocolWrapperData(this.protocols, this.pageMeta);
  ProtocolWrapperData.dummy()
      : protocols = List.generate(
          5,
          (index) => ProtocolData(
              index,
              'This is article $index',
              'This is article description $index',
              sampleImages[Random().nextInt(sampleImages.length - 1)],
              Random().nextBool()),
        ),
        pageMeta = PageMetaData(true);

  factory ProtocolWrapperData.fromJson(Map<String, dynamic> json) =>
      _$ProtocolWrapperDataFromJson(json);
  @JsonKey(name: 'results')
  List<ProtocolData> protocols;
  @JsonKey(name: 'meta')
  final PageMetaData pageMeta;

  ProtocolWrapperEntity asEntity() => ProtocolWrapperEntity(
      protocols.map((e) => e.asEntity()).toList(), pageMeta.asEntity());
}

var sampleImages = [
  'https://plus.unsplash.com/premium_photo-1667762241847-37471e8c8bc0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aGVhbHRofGVufDB8fDB8fHww',
  'https://images.unsplash.com/photo-1519996529931-28324d5a630e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGhlYWx0aHxlbnwwfHwwfHx8MA%3D%3D',
  'https://plus.unsplash.com/premium_photo-1672046218112-30a20c735686?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGhlYWx0aCUyMGFuZCUyMGZpdG5lc3N8ZW58MHx8MHx8fDA%3D',
  'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGhlYWx0aCUyMGFuZCUyMGZpdG5lc3N8ZW58MHx8MHx8fDA%3D',
  'https://plus.unsplash.com/premium_photo-1688464907499-1cfaf2ca48fb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDF8fGhlYWx0aCUyMGFuZCUyMGZpdG5lc3N8ZW58MHx8MHx8fDA%3D'
];
