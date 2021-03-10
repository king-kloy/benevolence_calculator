import 'dart:io';

import 'package:benevolence_calculator/src/core/models/customer_model.dart';
import 'package:benevolence_calculator/src/core/models/delivery_model.dart';
import 'package:flutter/material.dart';

class ExpansionCard extends StatelessWidget {
  final CustomerModel customerModel;
  final DeliveryModel deliveryModel;

  ExpansionCard({@required this.customerModel, this.deliveryModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 2.0,
      child: ExpansionTile(
        backgroundColor: Colors.white,
        childrenPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
        title: _buildTitle(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total price'),
              Text(
                '${deliveryModel.totalPrice}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Bread Quantities',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Small (GH¢2.00 each)'),
              Text(
                '${deliveryModel.smallBreadQty}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Big (GH¢2.50 each)'),
              Text(
                '${deliveryModel.bigBreadQty}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bigger (GH¢3.00 each)'),
              Text(
                '${deliveryModel.biggerBreadQty}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bigger (GH¢3.50 each)'),
              Text(
                '${deliveryModel.thirtyFiveBreadQty}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Biggest (GH¢4.00 each)'),
              Text(
                '${deliveryModel.biggestBreadQty}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Most Biggest (GH¢4.50 each)'),
              Text(
                '${deliveryModel.mostBiggestBreadQty}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Round (GH¢5.00 per set)'),
              Text(
                '${deliveryModel.roundBreadQty}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }

  // title with arrow icon for expanded card
  Widget _buildTitle() {
    return Row(
      children: <Widget>[
        customerModel.imagePath.isEmpty
            ? Container(
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/user-profile.png")),
                ),
                height: 50,
                width: 50,
              )
            : ClipOval(
                child: Image.file(
                  File(customerModel.imagePath),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customerModel.name,
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              '${deliveryModel.deliveryDate}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ],
    );
  }
}
