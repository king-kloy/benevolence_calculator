import 'dart:async';

import 'package:benevolence_calculator/src/core/service/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../locator.dart';

part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final Api _api = locator<Api>();

  SummaryBloc() : super(SummaryInitial());

  @override
  Stream<SummaryState> mapEventToState(
    SummaryEvent event,
  ) async* {
    if (event is GetRecordSummary) {
      yield SummaryLoading();
      final Map<String, dynamic> recordSummary =
          await _api.fetchRecordSummary(event.customerId);
      yield SummaryLoaded(recordSummary: recordSummary);
    }
  }
}
