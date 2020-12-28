import 'dart:io';

import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  final String imagePath, name;

  CustomerCard({this.imagePath, this.name});

  @override
  Widget build(BuildContext context) => Container(
        height: 180,
        width: 150,
        margin: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 5.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              imagePath.isEmpty
                  ? Container(
                      margin: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("assets/user-profile.png")),
                      ),
                      height: 80,
                      width: 80,
                    )
                  : ClipOval(
                      child: Image.file(
                        File(imagePath),
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
              Text(
                name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}
