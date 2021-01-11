import 'package:benevolence_calculator/src/core/bloc/customers_bloc.dart';
import 'package:benevolence_calculator/src/core/models/customer_model.dart';
import 'package:benevolence_calculator/src/screens/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/customer_card.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CustomersBloc>(context).add(GetCustomers());

    return Scaffold(
      appBar: AppBar(
        title: Text("Customers"),
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
                return _buildCustomersWidget(state.customers);
              } else {
                return Loading();
              }
            },
          ),
        ),
      ),
    );
  }

  Column _buildCustomersWidget(List<CustomerModel> customers) {
    return Column(
      children: customers
          .map((customer) => CustomerCard(
                customer: customer,
              ))
          .toList(),
    );
  }
}
