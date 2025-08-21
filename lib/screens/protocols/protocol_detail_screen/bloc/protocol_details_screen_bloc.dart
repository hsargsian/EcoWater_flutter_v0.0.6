import 'package:bloc/bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:echowater/core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import 'package:echowater/core/domain/entities/protocol_details_entity/protocol_details_entity.dart';
import 'package:meta/meta.dart';

import '../../../../core/domain/entities/CustomizeProtocolActiveRequestEntity/customize_protocol_active_request_entity.dart';
import '../../../../core/domain/repositories/protocol_repository.dart';

part 'protocol_details_screen_event.dart';
part 'protocol_details_screen_state.dart';

class ProtocolDetailsScreenBloc extends Bloc<ProtocolDetailsScreenEvent, ProtocolDetailsScreenState> {
  ProtocolDetailsScreenBloc({required ProtocolRepository protocolRepository})
      : _protocolRepository = protocolRepository,
        super(ProtocolDetailsScreenInitial()) {
    on<FetchProtocolDetailsEvent>(_onFetchProtocolDetails);
    on<UpdateProtocolGoalEvent>(_onUpdateProtocolGoal);
    on<DeleteUserProtocolEvent>(_onDeleteUserProtocol);
  }

  final ProtocolRepository _protocolRepository;
  List<CalendarEventData> events = [];

  Future<void> _onFetchProtocolDetails(FetchProtocolDetailsEvent event, Emitter<ProtocolDetailsScreenState> emit) async {
    emit(FetchingDetailsState());

    final response = await _protocolRepository.fetchProtocolDetails(event.id, event.protocolType);
    response.when(success: (response) {
      emit(FetchedProtocolDetailsState(response));
    }, error: (error) {
      emit(ProtocolDetailsFetchApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onUpdateProtocolGoal(UpdateProtocolGoalEvent event, Emitter<ProtocolDetailsScreenState> emit) async {
    emit(FetchingDetailsState());

    final response = await _protocolRepository.updateProtocolGoal(event.model);
    response.when(success: (response) {
      emit(FetchedProtocolDetailsState(response, isRefreshedPage: true));
    }, error: (error) {
      emit(ProtocolDetailsFetchApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onDeleteUserProtocol(DeleteUserProtocolEvent event, Emitter<ProtocolDetailsScreenState> emit) async {
    emit(FetchingDetailsState());
    final response = await _protocolRepository.deleteUserProtocol(event.id);
    response.when(success: (response) {
      emit(DeleteUserProtocolState(response));
    }, error: (error) {
      emit(ProtocolDetailsFetchApiErrorState(error.toMessage()));
    });
  }
}
