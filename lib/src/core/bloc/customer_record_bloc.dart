import 'dart:async';

import 'package:benevolence_calculator/src/core/service/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../locator.dart';

part 'customer_record_event.dart';
part 'customer_record_state.dart';

class CustomerRecordBloc
    extends Bloc<CustomerRecordEvent, CustomerRecordState> {
  final Api _api = locator<Api>();

  CustomerRecordBloc() : super(CustomerRecordInitial());

  @override
  Stream<CustomerRecordState> mapEventToState(
    CustomerRecordEvent event,
  ) async* {
    if (event is GetCustomerRecord) {
      yield CustomerRecordLoading();
      // fetch customer, deliveries and payments

      final Map<String, dynamic> customerRecord =
          await _api.fetchCustomerRecord(event.customerId);
      yield CustomerRecordLoaded(customerRecord: customerRecord);
    }
  }
}
