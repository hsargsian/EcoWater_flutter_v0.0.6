import 'dart:math';

import 'package:echowater/core/domain/entities/protocol_wrapper_entity/protocol_entity.dart';
import 'package:uuid/uuid.dart';

class ProtocolsWrapperDomain {
  ProtocolsWrapperDomain(this._protocols, this.hasMore);
  final List<ProtocolDomain> _protocols;
  bool hasFetched = false;
  bool hasMore;

  List get protocols => _protocols;

  static ProtocolsWrapperDomain get getProtocolsWrapperDomain =>
      ProtocolsWrapperDomain(
          [
            'https://plus.unsplash.com/premium_photo-1667762241847-37471e8c8bc0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aGVhbHRofGVufDB8fDB8fHww',
            'https://images.unsplash.com/photo-1519996529931-28324d5a630e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGhlYWx0aHxlbnwwfHwwfHx8MA%3D%3D',
            'https://plus.unsplash.com/premium_photo-1672046218112-30a20c735686?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGhlYWx0aCUyMGFuZCUyMGZpdG5lc3N8ZW58MHx8MHx8fDA%3D',
            'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGhlYWx0aCUyMGFuZCUyMGZpdG5lc3N8ZW58MHx8MHx8fDA%3D',
            'https://plus.unsplash.com/premium_photo-1688464907499-1cfaf2ca48fb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDF8fGhlYWx0aCUyMGFuZCUyMGZpdG5lc3N8ZW58MHx8MHx8fDA%3D'
          ]
              .map((item) => ProtocolDomain(ProtocolEntity(const Uuid().v4(),
                  'title', 'description', item, Random().nextBool())))
              .toList(),
          false);
}

class ProtocolDomain {
  ProtocolDomain(this._entity);
  final ProtocolEntity _entity;

  String get image => _entity.url;
  String get title => _entity.title;
  String get description => _entity.description;
  bool get isActive => _entity.isActive;
  String get id => _entity.id;
}
