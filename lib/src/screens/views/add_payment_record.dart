import 'package:benevolence_calculator/src/core/bloc/customers_bloc.dart';
import 'package:benevolence_calculator/src/core/models/customer_model.dart';
import 'package:benevolence_calculator/src/core/models/payment_model.dart';
import 'package:benevolence_calculator/src/core/service/api.dart';
import 'package:benevolence_calculator/src/screens/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../../locator.dart';
import '../../util/date_time.dart';

class AddPaymentRecord extends StatefulWidget {
  @override
  _AddPaymentRecordState createState() => _AddPaymentRecordState();
}

class _AddPaymentRecordState extends State<AddPaymentRecord> {
  Api _api = locator<Api>();

  // customer selected from the dropdown
  CustomerModel _currentCustomer;
  // form key
  final _formKey = GlobalKey<FormState>();
  // scaffold key
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //
  TextEditingController _amountController;
  String _dateTime;

  DateTimeHelper dateTimeHelper;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: "");
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
          title: Text("Add Payment Record"),
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

                return _buildRecordForm(
                    context: context, customers: state.customers);
              } else {
                return Loading();
              }
            },
          ),
        )),
      ),
    );
  }

  Form _buildRecordForm({BuildContext context, List<CustomerModel> customers}) {
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
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount (GH¢0.00)',
            ),
          ),
          SizedBox(height: 20),
          Text("Payment date"),
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
                    _dateTime == null
                        ? dateTimeHelper.formattedDate
                        : " $_dateTime",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
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
                print("Save payment info");
                // save delivery if customer is selected
                if (_currentCustomer != null) {
                  if (_amountController.text != null &&
                      _amountController.text.isNotEmpty) {
                        print(_amountController.text.isNotEmpty);
                    _api.saveCustomerPayment(PaymentModel(
                        customerId: _currentCustomer.id,
                        amount: _amountController.text,
                        paymentDate: _dateTime));
                    _formKey.currentState?.reset();
                    _onSaving(context);
                  } else {
                    _showSnackBar('Kindly enter amount saving.');
                  }
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
      _showSnackBar('Customer payment saved successfully');
    });
  }

  void _showSnackBar(String value) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(value)));
  }
}
