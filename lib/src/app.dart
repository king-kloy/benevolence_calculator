import 'package:benevolence_calculator/src/core/bloc/customers_with_deliveries_bloc.dart';
import 'package:benevolence_calculator/src/core/bloc/summary_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/bloc/customers_bloc.dart';
import 'screens/views/add_delivery_record.dart';
import 'screens/views/add_new_customer.dart';
import 'screens/views/add_payment_record.dart';
import 'screens/views/customers.dart';
import 'screens/views/home.dart';
import 'screens/views/records.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bottom navigation bar index for widget to display
  int _bottomNavIndex = 0;

  List<Widget> _widgetOptions = <Widget>[Home(), Customers(), Records()];

  @override
  Widget build(BuildContext context) {
    double mScreenHeight = MediaQuery.of(context).size.height;
    double mScreenWidth = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CustomersBloc(),
        ),
        BlocProvider(
          create: (context) => CustomersWithDeliveriesBloc(),
        ),
        BlocProvider(
          create: (context) => SummaryBloc(),
        ),
      ],
      child: Scaffold(
        body: _widgetOptions[_bottomNavIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomNavIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.group), label: "Customers"),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: "Records"),
            ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          tooltip: 'Add New',
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text('Choose option'),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      content: Container(
                        width: mScreenWidth,
                        height: mScreenHeight / 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color(0xFFFFFF),
                        ),
                        child: Column(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AddNewCustomer()));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.person_add),
                                Text("Add new customer")
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                          create: (context) => CustomersBloc(),
                                          child: AddDeliveryRecord())));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.post_add),
                                Text("Add delivery record")
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AddPaymentRecord()));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.list_alt),
                                Text("Add payment record")
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ));
          },
        ),
      ),
    );
  }

  _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }
}
