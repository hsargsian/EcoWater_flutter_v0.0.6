import 'package:echowater/core/domain/domain_models/protocols_wrapper_domain.dart';
import 'package:echowater/core/domain/entities/protocol_wrapper_entity/protocol_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../page_meta_entity/page_meta_entity.dart';

part 'protocol_wrapper_entity.g.dart';

@JsonSerializable()
class ProtocolWrapperEntity {
  ProtocolWrapperEntity(
    this.protocols,
    this.pageMeta,
  );

  factory ProtocolWrapperEntity.fromJson(Map<String, dynamic> json) =>
      _$ProtocolWrapperEntityFromJson(json);

  final List<ProtocolEntity> protocols;
  final PageMetaEntity pageMeta;

  Map<String, dynamic> toJson() => _$ProtocolWrapperEntityToJson(this);
  ProtocolsWrapperDomain toDomain() => ProtocolsWrapperDomain(
        protocols.map((e) => e.toDomain()).toList(),
        pageMeta.hasMore,
      );
}
