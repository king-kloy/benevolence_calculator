import 'dart:io';

import 'package:benevolence_calculator/src/core/models/customer_model.dart';
import 'package:benevolence_calculator/src/screens/views/customer_record.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;

  CustomerCard({this.customer});

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 5.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CustomerRecord(
                                customerId: customer.id,
                              )));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    customer.imagePath.isEmpty
                        ? Container(
                            margin: EdgeInsets.all(10.0),
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
                              File(customer.imagePath),
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Text(
                      customer.name,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
              customer.phoneNumber == null || customer.phoneNumber.isEmpty
                  ? SizedBox()
                  : IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () {
                        _makePhoneCall(customer.phoneNumber);
                      },
                    )
            ],
          ),
        ),
      );

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      return;
    }
  }
}
