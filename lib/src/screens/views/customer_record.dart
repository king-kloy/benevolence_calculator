import 'dart:io';

import 'package:benevolence_calculator/src/core/bloc/customer_record_bloc.dart';
import 'package:benevolence_calculator/src/core/models/delivery_model.dart';
import 'package:benevolence_calculator/src/core/models/payment_model.dart';
import 'package:benevolence_calculator/src/core/service/api.dart';
import 'package:benevolence_calculator/src/screens/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';

class CustomerRecord extends StatefulWidget {
  final int customerId;

  const CustomerRecord({Key key, this.customerId}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<CustomerRecord> {
  final Api _api = locator<Api>();

  // scaffold key
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerRecordBloc(),
      child: DefaultTabController(
        length: 2,
        child: BlocBuilder<CustomerRecordBloc, CustomerRecordState>(
            builder: (context, state) {
          if (state is CustomerRecordInitial) {
            // load customer records by triggering GetCustomerRecord event
            BlocProvider.of<CustomerRecordBloc>(context)
                .add(GetCustomerRecord(customerId: widget.customerId));
            return Scaffold(body: Loading());
          } else if (state is CustomerRecordLoading) {
            return Scaffold(body: Loading());
          } else if (state is CustomerRecordLoaded) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    state.customerRecord["customer"].imagePath.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage("assets/user-profile.png")),
                            ),
                            height: 30,
                            width: 30,
                          )
                        : ClipOval(
                            child: Image.file(
                              File(state.customerRecord["customer"].imagePath),
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Text("${state.customerRecord["customer"].name}"),
                  ],
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(
                        child: Text('Deliveries',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .merge(TextStyle(color: Colors.white)))),
                    Tab(
                        child: Text('Payments',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .merge(TextStyle(color: Colors.white))))
                  ],
                ),
              ),
              body: TabBarView(children: [
                SingleChildScrollView(
                  child:
                      _renderDeliveriesView(context, state.customerRecord["deliveries"]),
                ),
                SingleChildScrollView(
                  child: _renderPaymentsView(context, state.customerRecord["payments"]),
                ),
              ]),
            );
          } else
            return Scaffold(body: Loading());
        }),
      ),
    );
  }

  _renderPaymentsView(BuildContext context, List<PaymentModel> payments) {
    if (payments.isEmpty) return Center(child: Text("No payments yet"));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
          children:
              payments.map((payment) => _buildPaymentCard(context, payment)).toList()),
    );
  }

  _renderDeliveriesView(BuildContext context, List<DeliveryModel> deliveries) {
    if (deliveries.isEmpty) return Center(child: Text("No deliveries yet"));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
          children: deliveries
              .map((delivery) => _buildDeliveryCard(context, delivery))
              .toList()),
    );
  }

  Card _buildPaymentCard(BuildContext context, PaymentModel paymentModel) {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${paymentModel.paymentDate}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _api.removePayment(paymentModel.id);
                _showSnackBar("Payment record deleted successfully");
                BlocProvider.of<CustomerRecordBloc>(context)
                    .add(GetCustomerRecord(customerId: widget.customerId));
              },
            )
          ],
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount'),
              Text(
                '${paymentModel.amount}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  Card _buildDeliveryCard(BuildContext context, DeliveryModel deliveryModel) {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${deliveryModel.deliveryDate}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _api.removeDelivery(deliveryModel.id);
                _showSnackBar("Delivery record deleted successfully");
                BlocProvider.of<CustomerRecordBloc>(context)
                    .add(GetCustomerRecord(customerId: widget.customerId));
              },
            )
          ],
        ),
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

  void _showSnackBar(String value) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(value)));
  }
}
