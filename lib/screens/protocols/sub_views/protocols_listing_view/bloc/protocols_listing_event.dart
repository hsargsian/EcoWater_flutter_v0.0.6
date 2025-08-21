part of 'protocols_listing_bloc.dart';

@immutable
abstract class ProtocolsListingEvent {}

class FetchProtocolsListingEvent extends ProtocolsListingEvent {
  FetchProtocolsListingEvent(this.fetchStyle, this.category, this.type);
  final FetchStyle fetchStyle;
  final String? category;
  final String? type;
}

class SetProtocolsListingType extends ProtocolsListingEvent {
  SetProtocolsListingType(this.isSubSectionView, this.protocolCategory);
  final bool isSubSectionView;
  final String? protocolCategory;
}
