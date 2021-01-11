import 'package:benevolence_calculator/src/core/bloc/customers_bloc.dart';
import 'package:benevolence_calculator/src/core/bloc/summary_bloc.dart';
import 'package:benevolence_calculator/src/core/models/customer_model.dart';
import 'package:benevolence_calculator/src/screens/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Records extends StatefulWidget {
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  // customer selected from the dropdown
  CustomerModel _currentCustomer;

  // scaffold key
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CustomersBloc>(context).add(GetCustomers());

    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Records"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<CustomersBloc, CustomersState>(
          builder: (context, state) {
            if (state is CustomersInitial) {
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
    );
  }

  Form _buildForm({BuildContext context, List<CustomerModel> customers}) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField(
              items: customers.map((CustomerModel selectedCustomer) {
                return new DropdownMenuItem(
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
          SizedBox(height: 20.0),
          Center(
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Text(
                'Check Balance',
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              ),
              onPressed: () {
                print("Get summary...");
                if (_currentCustomer == null) {
                  _showSnackBar("Kindly Choose customer");
                } else {
                  BlocProvider.of<SummaryBloc>(context)
                      .add(GetRecordSummary(customerId: _currentCustomer.id));
                }
              },
            ),
          ),
          SizedBox(height: 20),
          BlocBuilder<SummaryBloc, SummaryState>(
            builder: (context, state) {
              if (state is SummaryInitial) {
                return SizedBox();
              } else if (state is SummaryLoading) {
                return Loading();
              } else if (state is SummaryLoaded) {
                return _buildSummaryCard(
                    state.recordSummary["deliveries"],
                    state.recordSummary["payments"],
                    state.recordSummary["balance"]);
              } else {
                return Loading();
              }
            },
          )
        ],
      ),
    );
  }

  Card _buildSummaryCard(
      [double totalDeliveries = 0.0,
      double totalPayments = 0.0,
      double balance = 0.0]) {
    return Card(
      margin: EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
          /*   Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total deliveries'),
                Text(
                  'GH¢$totalDeliveries',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total payments'),
                Text(
                  'GH¢$totalPayments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Divider(
              color: Colors.black,
            ), */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance'),
                Text(
                  'GH¢$balance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String value) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(value)));
  }
}
