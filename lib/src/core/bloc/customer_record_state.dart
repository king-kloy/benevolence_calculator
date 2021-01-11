part of 'customer_record_bloc.dart';

abstract class CustomerRecordState extends Equatable {
  const CustomerRecordState();

  @override
  List<Object> get props => [];
}

class CustomerRecordInitial extends CustomerRecordState {
  const CustomerRecordInitial();
}

class CustomerRecordLoading extends CustomerRecordState {
  const CustomerRecordLoading();
}

class CustomerRecordLoaded extends CustomerRecordState {
  final Map<String, dynamic> customerRecord;
  const CustomerRecordLoaded({this.customerRecord});
}
