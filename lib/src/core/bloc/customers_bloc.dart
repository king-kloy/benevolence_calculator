import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/models/customer_model.dart';
import '../../core/service/api.dart';
import '../../../locator.dart';

part 'customers_event.dart';
part 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final Api _api = locator<Api>();

  CustomersBloc() : super(CustomersInitial());

  @override
  Stream<CustomersState> mapEventToState(
    CustomersEvent event,
  ) async* {
    if (event is GetCustomers) {
      yield CustomersLoading();

      final customers = await _api.fetchCustomers().then((results) => results);
      yield CustomersLoaded(customers: customers);
    }
  }
}
