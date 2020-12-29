import 'package:benevolence_calculator/src/core/bloc/customers_bloc.dart';
import 'package:benevolence_calculator/src/core/models/customer_model.dart';
import 'package:benevolence_calculator/src/core/models/delivery_model.dart';
import 'package:benevolence_calculator/src/core/service/api.dart';
import 'package:benevolence_calculator/src/screens/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../../locator.dart';
import '../../util/date_time.dart';

class AddDeliveryRecord extends StatefulWidget {
  @override
  _AddDeliveryRecordState createState() => _AddDeliveryRecordState();
}

class _AddDeliveryRecordState extends State<AddDeliveryRecord> {
  Api _api = locator<Api>();

  // customer selected from the dropdown
  CustomerModel _currentCustomer;
  // form key
  final _formKey = GlobalKey<FormState>();
  // scaffold key
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const double SMALL_BREAD_UNIT_PRICE = 2.0;
  static const double BIG_BREAD_UNIT_PRICE = 2.5;
  static const double BIGGER_BREAD_UNIT_PRICE = 3.0;
  static const double BIGGEST_BREAD_UNIT_PRICE = 4.0;
  static const double ROUND_BREAD_UNIT_PRICE = 5.0;

  // textfield controllers
  TextEditingController _smallBreadController;
  TextEditingController _bigBreadController;
  TextEditingController _biggerBreadController;
  TextEditingController _biggestBreadController;
  TextEditingController _roundBreadController;

  DateTimeHelper dateTimeHelper;

  String _dateTime;
  double _totalPrice = 0.00;

  @override
  initState() {
    super.initState();
    _smallBreadController = TextEditingController(text: "");
    _bigBreadController = TextEditingController(text: "");
    _biggerBreadController = TextEditingController(text: "");
    _biggestBreadController = TextEditingController(text: "");
    _roundBreadController = TextEditingController(text: "");

    // set date
    dateTimeHelper = DateTimeHelper();
    setState(() => _dateTime = dateTimeHelper.formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomersBloc(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Add Delivery Record"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<CustomersBloc, CustomersState>(
            builder: (context, state) {
              if (state is CustomersInitial) {
                BlocProvider.of<CustomersBloc>(context).add(GetCustomers());
                return Loading();
              } else if (state is CustomersLoading) {
                return Loading();
              } else if (state is CustomersLoaded) {
                if (state.customers.length <= 0)
                  return Center(
                      child: Text("No customer added yet. Kindly add one."));

                return _buildForm(context: context, customers: state.customers);
              } else {
                return Loading();
              }
            },
          ),
        )),
      ),
    );
  }

  Form _buildForm({BuildContext context, List<CustomerModel> customers}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField(
              items: customers.map((CustomerModel selectedCustomer) {
                return DropdownMenuItem(
                  value: selectedCustomer,
                  child: Text(selectedCustomer.name),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() => _currentCustomer = newValue);
              },
              value: _currentCustomer,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Choose Customer")),
          TextFormField(
            controller: _smallBreadController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Small (GH¢2.00 each) Quantity',
            ),
          ),
          TextFormField(
            controller: _bigBreadController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Big (GH¢2.50 each) Quantity',
            ),
          ),
          TextFormField(
            controller: _biggerBreadController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Bigger (GH¢3.00 each) Quantity',
            ),
          ),
          TextFormField(
            controller: _biggestBreadController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Biggest (GH¢4.0 each) Quantity',
            ),
          ),
          TextFormField(
            controller: _roundBreadController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Round (GH¢5.00 per set) Quantity',
            ),
          ),
          SizedBox(height: 20),
          Text("Delivery date"),
          RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            onPressed: () {
              DatePicker.showDatePicker(context,
                  theme: DatePickerTheme(
                    containerHeight: 210.0,
                  ),
                  showTitleActions: true,
                  minTime: DateTime(2020, 1, 1),
                  maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                String dateToStr = date.toString();

                setState(() {
                  _dateTime = dateToStr.split(' ')[0];
                });
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.date_range,
                    size: 18.0,
                    color: Color(0xff244e98),
                  ),
                  Text(
                    " $_dateTime",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text("Calculate cost"),
          Row(
            children: [
              FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  double calcResult = _calculateCost();
                   print(calcResult);
                  setState(() =>
                      _totalPrice = calcResult);
                },
                child: Icon(Icons.calculate, color: Colors.white),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: Color(0xff17a2b8),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Text("GH¢ $_totalPrice",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
              color: Theme.of(context).primaryColor,
              shape: StadiumBorder(),
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              ),
              onPressed: () {
                double calcResult = _calculateCost();

                // save delivery if customer is selected
                if (_currentCustomer != null) {
                  _api.saveCustomerDelivery(DeliveryModel(
                      customerId: _currentCustomer.id,
                      totalPrice: "$calcResult",
                      smallBreadQty: _smallBreadController.text ?? "0",
                      bigBreadQty: _bigBreadController.text ?? "0",
                      biggerBreadQty: _biggerBreadController.text ?? "0",
                      biggestBreadQty:_biggestBreadController.text ?? "0",
                      roundBreadQty: _roundBreadController.text ?? "0",
                      deliveryDate: _dateTime));
                  _formKey.currentState?.reset();
                  _onSaving(context);
                } else {
                  _showSnackBar('Kindly select customer before saving.');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _calculateCost() {
    double smallBread = _smallBreadController.text.isEmpty
        ? 0.0
        : double.parse(_smallBreadController.text);

    double bigBread = _bigBreadController.text.isEmpty
        ? 0.0
        : double.parse(_bigBreadController.text);

    double biggerBread = _biggerBreadController.text.isEmpty
        ? 0.0
        : double.parse(_biggerBreadController.text);

    double biggestBread = _biggestBreadController.text.isEmpty
        ? 0.0
        : double.parse(_biggestBreadController.text);

    double roundBread = _roundBreadController.text.isEmpty
        ? 0.0
        : double.parse(_roundBreadController.text);

    double totalPrice = (smallBread * SMALL_BREAD_UNIT_PRICE) +
        (bigBread * BIG_BREAD_UNIT_PRICE) +
        (biggerBread * BIGGER_BREAD_UNIT_PRICE) +
        (biggestBread * BIGGEST_BREAD_UNIT_PRICE) +
        (roundBread * ROUND_BREAD_UNIT_PRICE);

    return totalPrice;
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
      _showSnackBar('Customer delivery saved successfully');
    });
  }

  void _showSnackBar(String value) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(value)));
  }
}
