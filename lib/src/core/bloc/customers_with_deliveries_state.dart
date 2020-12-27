part of 'customers_with_deliveries_bloc.dart';

abstract class CustomersWithDeliveriesState extends Equatable {
  const CustomersWithDeliveriesState();

  @override
  List<Object> get props => [];
}

class CustomersWithDeliveriesInitial extends CustomersWithDeliveriesState {
  const CustomersWithDeliveriesInitial();
}

class CustomersWithDeliveriesLoading extends CustomersWithDeliveriesState {
  const CustomersWithDeliveriesLoading();
}

class CustomersWithDeliveriesLoaded extends CustomersWithDeliveriesState {
  final List<Map<String, dynamic>> customersWithDeliveries;
  const CustomersWithDeliveriesLoaded({this.customersWithDeliveries});
}
