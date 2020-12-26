import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CustomerModel extends Equatable {
  int id;
  String name;
  String imagePath;
  String phoneNumber;
  String address;

  CustomerModel(
      {this.id, this.name, this.imagePath, this.phoneNumber, this.address});

  // converts customer details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'phoneNumber': phoneNumber,
      'address': address
    };

    return map;
  }

  // destruct map of customer
  CustomerModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    imagePath = map['imagePath'];
    phoneNumber = map['phoneNumber'];
    address = map['address'];
  }

  @override
  List<Object> get props => [id, name, imagePath, phoneNumber, address];
}
