import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../locator.dart';
import '../../core/models/customer_model.dart';
import '../../core/service/api.dart';
import '../../util/date_time.dart';
import '../components/toast_message.dart';

class AddNewCustomer extends StatefulWidget {
  @override
  _AddNewCustomerState createState() => _AddNewCustomerState();
}

class _AddNewCustomerState extends State<AddNewCustomer> {
  Api _api = locator<Api>();

  // form key
  final _formKeyScreen = GlobalKey<FormState>();
  // scaffold key
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _imagePath = '';
  File _imageFile;
  final picker = ImagePicker();

  // textfield controllers
  TextEditingController _nameController;
  TextEditingController _phoneNumberController;
  TextEditingController _addressController;

  DateTimeHelper dateTimeHelper = DateTimeHelper();

  @override
  initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _phoneNumberController = TextEditingController(text: "");
    _addressController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add New Customer"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKeyScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  height: 100.0,
                  width: 100.0,
                  child: Stack(
                    children: <Widget>[
                      _imagePath == ''
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/user-profile.png")),
                              ),
                              height: 100.0,
                              width: 100.0,
                            )
                          : ClipOval(
                              child: Image.file(
                                _imageFile,
                                height: 100.0,
                                width: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                          bottom: 0,
                          top: 70,
                          left: 65,
                          child: IconButton(
                            onPressed: getImage,
                            icon: Icon(
                              Icons.photo_camera,
                              color: const Color(0xff244e98),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  onPressed: () {
                    // don't save customer info if name and phoneNumber isEmpty
                    if (_nameController.text.isEmpty) {
                      toastMessage(context,
                          "Kindly provide customer name and phone number.");
                    } else {
                      CustomerModel customerModel = CustomerModel(
                          imagePath: _imagePath ?? "",
                          name: _nameController.text ?? "",
                          phoneNumber: _phoneNumberController.text ?? "",
                          address: _addressController.text ?? "");
                      // save customer details
                      _api.saveCustomerDetails(customerModel);
                      _formKeyScreen.currentState?.reset();
                      _onSaving(context);
                    }
                  },
                  child: Text(
                    'Save',
                    style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future getImage() async {
    // picks image from camera
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    var fileName = p.basename(pickedFile.path);

    // copy image file to a  path
    File image = File('$appDocPath/$fileName');

    // update image file
    setState(() {
      _imageFile = image;
      _imagePath = '$appDocPath/$fileName';
    });
  }

  void _onSaving(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text("Saving"),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      toastMessage(context, 'Customer data saved successfully');
    });
  }
}
