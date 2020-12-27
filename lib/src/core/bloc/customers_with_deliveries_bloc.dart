import 'dart:async';

import 'package:benevolence_calculator/src/core/service/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../locator.dart';

part 'customers_with_deliveries_event.dart';
part 'customers_with_deliveries_state.dart';

class CustomersWithDeliveriesBloc
    extends Bloc<CustomersWithDeliveriesEvent, CustomersWithDeliveriesState> {
  final Api _api = locator<Api>();

  CustomersWithDeliveriesBloc() : super(CustomersWithDeliveriesInitial());

  @override
  Stream<CustomersWithDeliveriesState> mapEventToState(
    CustomersWithDeliveriesEvent event,
  ) async* {
    if (event is GetCustomersWithDeliveries) {
      yield CustomersWithDeliveriesLoading();

      final customersWithDeliveries = await _api.fetchRecentDeliveries();
      yield CustomersWithDeliveriesLoaded(
          customersWithDeliveries: customersWithDeliveries);
    }
  }
}
