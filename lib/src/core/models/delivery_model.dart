import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class DeliveryModel extends Equatable {
  int id;
  int customerId;
  String totalPrice;
  String smallBreadQty;
  String bigBreadQty;
  String biggerBreadQty;
  String biggestBreadQty;
  String thirtyFiveBreadQty;
  String mostBiggestBreadQty;
  String roundBreadQty;
  String deliveryDate;

  DeliveryModel(
      {this.id,
      this.customerId,
      this.totalPrice,
      this.smallBreadQty,
      this.bigBreadQty,
      this.biggerBreadQty,
      this.biggestBreadQty,
      this.thirtyFiveBreadQty,
      this.mostBiggestBreadQty,
      this.roundBreadQty,
      this.deliveryDate});

  // converts delivery details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'customerId': customerId,
      'totalPrice': totalPrice,
      'smallBreadQty': smallBreadQty,
      'bigBreadQty': bigBreadQty,
      'biggerBreadQty': biggerBreadQty,
      'biggestBreadQty': biggestBreadQty,
      'thirtyFiveBreadQty': thirtyFiveBreadQty,
      'mostBiggestBreadQty': mostBiggestBreadQty,
      'roundBreadQty': roundBreadQty,
      'deliveryDate': deliveryDate,
    };

    return map;
  }

  // destruct map of delivery model
  DeliveryModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    customerId = map['customerId'];
    totalPrice = map['totalPrice'];
    smallBreadQty = map['smallBreadQty'];
    bigBreadQty = map['bigBreadQty'];
    biggerBreadQty = map['biggerBreadQty'];
    biggestBreadQty = map['biggestBreadQty'];
    thirtyFiveBreadQty = map['thirtyFiveBreadQty'];
    mostBiggestBreadQty = map['mostBiggestBreadQty'];
    roundBreadQty = map['roundBreadQty'];
    deliveryDate = map['deliveryDate'];
  }

  @override
  List<Object> get props => [
        id,
        customerId,
        totalPrice,
        smallBreadQty,
        bigBreadQty,
        biggerBreadQty,
        biggestBreadQty,
        thirtyFiveBreadQty,
        mostBiggestBreadQty,
        roundBreadQty,
        deliveryDate
      ];
}
