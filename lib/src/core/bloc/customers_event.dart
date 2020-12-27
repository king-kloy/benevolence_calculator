part of 'customers_bloc.dart';

@immutable
abstract class CustomersEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class GetCustomers extends CustomersEvent {
  GetCustomers();
}
