import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PaymentModel extends Equatable {
  int id;
  int customerId;
  String amount;
  String paymentDate;

  PaymentModel({this.id, this.customerId, this.amount, this.paymentDate});

  // converts payment details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'customerId': customerId,
      'amount': amount,
      'paymentDate': paymentDate,
    };

    return map;
  }

  // destruct map of payment model
  PaymentModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    customerId = map['customerId'];
    amount = map['amount'];
    paymentDate = map['paymentDate'];
  }

  @override
  List<Object> get props => [id, customerId, amount, paymentDate];
}
