part of 'customers_bloc.dart';

@immutable
abstract class CustomersState extends Equatable {
  const CustomersState();
  
  @override
  List<Object> get props => [];
}

class CustomersInitial extends CustomersState {
  const CustomersInitial();
}

class CustomersLoading extends CustomersState {
  const CustomersLoading();
}

class CustomersLoaded extends CustomersState {
  final List<CustomerModel> customers;
  const CustomersLoaded({this.customers});
}
