import 'package:bloc/bloc.dart';
import 'package:echowater/base/common_widgets/day_selection_view/day_selection_view.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/protocol_category.dart';
import 'package:echowater/core/domain/entities/protocol_wrapper_entity/protocol_category_entity.dart';
import 'package:flutter/material.dart';

import '../../../../base/utils/pair.dart';
import '../../../../core/domain/entities/protocol_details_entity/protocol_details_entity.dart';
import '../../../../core/domain/entities/protocol_routine_entity/protocol_routine_entity.dart';
import '../../../../core/domain/repositories/protocol_repository.dart';

part 'protocol_tab_dashboard_screen_event.dart';
part 'protocol_tab_dashboard_screen_state.dart';

class ProtocolTabBloc extends Bloc<ProtocolTabEvent, ProtocolTabDashboardListingState> {
  ProtocolTabBloc({required ProtocolRepository protocolRepository})
      : _protocolRepository = protocolRepository,
        super(ProtocolTabIdleState()) {
    on<FetchProtocolCategoriesEvent>(_onFetchProtocolCategories);
  }

  final ProtocolRepository _protocolRepository;
  Pair<List<ProtocolCategoryDomain>, bool> categories = Pair(first: [], second: false);

  ProtocolDetailsEntity? protocolDetailsEntity;

  Future<void> _onFetchProtocolCategories(
    FetchProtocolCategoriesEvent event,
    Emitter<ProtocolTabDashboardListingState> emit,
  ) async {
    emit(FetchingProtocolCategoriesState());

    final response = await _protocolRepository.fetchProtocolCategories();
    response.when(success: (categoriesResponse) {
      final categoriesDomains = categoriesResponse.map(ProtocolCategoryDomain.new).toList();
      final allCategory = ProtocolCategoryDomain(ProtocolCategoryEntity('All', 'all', -1))
        ..selected = true
        ..isAll = true;
      categoriesDomains.insert(0, allCategory);
      categories = Pair(first: categoriesDomains, second: true);
      emit(FetchedProtocolCategoriesState());
    }, error: (error) {
      emit(ProtocolTabFetchApiErrorState(error.toMessage()));
    });
  }

  ProtocolDetailsEntity getDefaultCustomProtocolData() {
    final routines = <ProtocolRoutineEntity>[
      ProtocolRoutineEntity(
        day: Day.monday.name.capitalizeFirst(),
        items: [],
        activeDay: true,
      ),
      ProtocolRoutineEntity(
        day: Day.tuesday.name.capitalizeFirst(),
        items: [],
        activeDay: true,
      ),
      ProtocolRoutineEntity(
        day: Day.wednesday.name.capitalizeFirst(),
        items: [],
        activeDay: true,
      ),
      ProtocolRoutineEntity(
        day: Day.thursday.name.capitalizeFirst(),
        items: [],
        activeDay: true,
      ),
      ProtocolRoutineEntity(
        day: Day.friday.name.capitalizeFirst(),
        items: [],
        activeDay: true,
      ),
      ProtocolRoutineEntity(
        day: Day.saturday.name.capitalizeFirst(),
        items: [],
        activeDay: false,
      ),
      ProtocolRoutineEntity(
        day: Day.sunday.name.capitalizeFirst(),
        items: [],
        activeDay: false,
      ),
    ];
    final defaultCustomProtocol = ProtocolDetailsEntity(
      id: -1,
      title: '',
      category: 'Custom',
      image: '',
      isActive: false,
      isTemplate: false,
      education: '',
      quotations: [],
      routines: routines,
    );

    return defaultCustomProtocol;
  }
}
