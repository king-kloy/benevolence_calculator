part of 'summary_bloc.dart';

abstract class SummaryState extends Equatable {
  const SummaryState();
  
  @override
  List<Object> get props => [];
}

class SummaryInitial extends SummaryState {
  const SummaryInitial();
}

class SummaryLoading extends SummaryState {
  const SummaryLoading();
}

class SummaryLoaded extends SummaryState {
  final Map<String, dynamic> recordSummary;

  const SummaryLoaded({this.recordSummary});
}
