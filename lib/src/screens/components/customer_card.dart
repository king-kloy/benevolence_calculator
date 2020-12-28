import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCard extends StatelessWidget {
  final String imagePath, name, phoneNumber;

  CustomerCard({this.imagePath, this.name, this.phoneNumber});

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
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  imagePath.isEmpty
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
                            File(imagePath),
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              phoneNumber == null || phoneNumber.isEmpty
                  ? SizedBox()
                  : IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () {
                        _makePhoneCall(phoneNumber);
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
