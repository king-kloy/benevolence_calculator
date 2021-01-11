part of 'customer_record_bloc.dart';

abstract class CustomerRecordEvent extends Equatable {
  const CustomerRecordEvent();

  @override
  List<Object> get props => [];
}


class GetCustomerRecord extends CustomerRecordEvent {
  final int customerId;
  GetCustomerRecord({this.customerId});
}

