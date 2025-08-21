import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/entities/customize_protocol_entity/customize_protocol_entity.dart';
import 'package:echowater/core/domain/entities/protocol_details_entity/protocol_details_entity.dart';
import 'package:meta/meta.dart';

import '../../../../../core/domain/entities/protocol_routine_entity/protocol_routine_entity.dart';
import '../../../../../core/domain/repositories/protocol_repository.dart';

part 'edit_custom_protocol_event.dart';
part 'edit_custom_protocol_state.dart';

class EditCustomProtocolBloc extends Bloc<EditCustomProtocolEvent, EditCustomProtocolState> {
  EditCustomProtocolBloc({required ProtocolRepository protocolRepository})
      : _protocolRepository = protocolRepository,
        super(EditCustomProtocolInitial()) {
    on<EditCustomProtocolEventFetch>(_onFetchCustomProtocolDetails);
    on<ResetCustomProtocolEvent>(_onResetCustomProtocolDetails);
    on<SaveCustomProtocolEvent>(_onSaveCustomProtocolDetails);
  }

  final ProtocolRepository _protocolRepository;

  Future<void> _onFetchCustomProtocolDetails(EditCustomProtocolEventFetch event, Emitter<EditCustomProtocolState> emit) async {
    emit(EditCustomProtocolLoading());

    final response = await _protocolRepository.fetchCustomizeProtocolData(event.id);
    response.when(success: (response) {
      emit(EditCustomProtocolLoaded(model: response));
    }, error: (error) {
      emit(EditCustomProtocolFetchApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onResetCustomProtocolDetails(ResetCustomProtocolEvent event, Emitter<EditCustomProtocolState> emit) async {
    final deepCopyRoutines = event.model.routines.map((routine) {
      final newItems = routine.items
          .map((item) => RoutineItemEntity(
                id: item.id,
                title: String.fromCharCodes(item.title.codeUnits),
                startTime: String.fromCharCodes(item.startTime.codeUnits),
                endTime: String.fromCharCodes(item.endTime.codeUnits),
              ))
          .toList();

      return ProtocolRoutineEntity(
        day: String.fromCharCodes(routine.day.codeUnits),
        activeDay: routine.activeDay,
        items: newItems,
      );
    }).toList();

    final deepCopyModel = CustomizeProtocolEntity(
      id: event.model.id,
      title: String.fromCharCodes(event.model.title.codeUnits),
      category: String.fromCharCodes(event.model.category.codeUnits),
      image: String.fromCharCodes(event.model.image.codeUnits),
      isActive: event.model.isActive,
      isTemplate: event.model.isTemplate,
      routines: deepCopyRoutines,
    );
    emit(EditCustomProtocolLoaded(model: deepCopyModel));
  }

  Future<void> _onSaveCustomProtocolDetails(SaveCustomProtocolEvent event, Emitter<EditCustomProtocolState> emit) async {
    emit(EditCustomProtocolLoading());

    final response = await _protocolRepository.saveCustomizeProtocolData(event.id, event.model, event.isFromBlankTemplate);
    response.when(success: (response) {
      emit(SaveCustomProtocolLoaded(model: response));
    }, error: (error) {
      emit(EditCustomProtocolFetchApiErrorState(error.toMessage()));
    });
  }
}
