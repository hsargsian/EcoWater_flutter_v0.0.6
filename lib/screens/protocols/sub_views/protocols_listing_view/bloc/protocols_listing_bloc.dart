import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/protocols_wrapper_domain.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/domain_models/fetch_style.dart';
import '../../../../../core/domain/repositories/protocol_repository.dart';

part 'protocols_listing_event.dart';
part 'protocols_listing_state.dart';

class ProtocolsListingBloc extends Bloc<ProtocolsListingEvent, ProtocolsListingState> {
  ProtocolsListingBloc({required ProtocolRepository protocolRepository})
      : _protocolRepository = protocolRepository,
        super(ProtocolsListingIdleState()) {
    on<FetchProtocolsListingEvent>(_onFetchProtocols);
    on<SetProtocolsListingType>(_onSetProtocolListingType);
  }

  final ProtocolRepository _protocolRepository;

  bool isSubsectionView = false;

  ProtocolsWrapperDomain protocolsWrapper = ProtocolsWrapperDomain([], false);

  Future<void> _onSetProtocolListingType(
    SetProtocolsListingType event,
    Emitter<ProtocolsListingState> emit,
  ) async {
    isSubsectionView = event.isSubSectionView;
  }

  Future<void> _onFetchProtocols(
    FetchProtocolsListingEvent event,
    Emitter<ProtocolsListingState> emit,
  ) async {
    emit(FetchingProtocolsListingState());
    var offset = 0;
    switch (event.fetchStyle) {
      case FetchStyle.normal:
      case FetchStyle.pullToRefresh:
        protocolsWrapper = ProtocolsWrapperDomain(
          [],
          false,
        );
      case FetchStyle.loadMore:
        offset = protocolsWrapper.protocols.length;
    }

    final response =
        await _protocolRepository.fetchProtocols(offset: offset, perPage: 10, type: event.type, category: event.category);
    response.when(success: (articlesResponse) {
      switch (event.fetchStyle) {
        case FetchStyle.normal:
        case FetchStyle.pullToRefresh:
          protocolsWrapper = articlesResponse.toDomain();

        case FetchStyle.loadMore:
          protocolsWrapper.hasMore = articlesResponse.pageMeta.hasMore;
          protocolsWrapper.protocols.addAll(articlesResponse.protocols.map((e) => e.toDomain()).toList());
      }
      protocolsWrapper.hasFetched = true;

      emit(FetchedProtocolsListingState());
    }, error: (error) {
      emit(ProtocolsFetchApiErrorState(error.toMessage()));
    });
  }
}
