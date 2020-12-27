part of 'customers_with_deliveries_bloc.dart';

abstract class CustomersWithDeliveriesEvent extends Equatable {
  const CustomersWithDeliveriesEvent();

  @override
  List<Object> get props => [];
}

class GetCustomersWithDeliveries extends CustomersWithDeliveriesEvent {
  GetCustomersWithDeliveries();
}
