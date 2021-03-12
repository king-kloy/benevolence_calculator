import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/customers_with_deliveries_bloc.dart';
import '../components/expansion_card.dart';
import '../components/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _userName = "Hanna";

  @override
  Widget build(BuildContext context) {

    double mScreenHeight = MediaQuery.of(context).size.height;
    double mScreenWidth = MediaQuery.of(context).size.width;

    BlocProvider.of<CustomersWithDeliveriesBloc>(context)
        .add(GetCustomersWithDeliveries());

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          child: ListView(
            children: [
              ListTile(
                trailing: Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.import_export),
                title: Text("Export"),
                onTap: () async {
                  /* var file = await _api.export();

                  if (file != null) {
                    toastMessage(context, "Successfully exported data");
                  } else {
                    toastMessage(context, "Failed to export data", Colors.red);
                  } */
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: mScreenHeight,
        width: mScreenWidth,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30), _buildAppBar(),
            SizedBox(height: 30),
            Text(
              'Hello, $_userName.',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'How\'s business?',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20),
            // search and filter search here
            Form(
              child: TextFormField(
                  autofocus: false,
                  style: TextStyle(fontSize: 18.0, color: Color(0xFFCECECE)),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(15.0),
                      prefixIcon: IconButton(
                          onPressed: () {}, icon: Icon(Icons.search)),
                      hintText: "Search customer",
                      filled: true,
                      fillColor: Color(0xFFCECECE).withOpacity(0.2))),
            ),
            SizedBox(height: 30),
            Text("Recent customers' records",
                style: Theme.of(context).textTheme.headline5),
            BlocBuilder<CustomersWithDeliveriesBloc,
                CustomersWithDeliveriesState>(
              builder: (context, state) {
                if (state is CustomersWithDeliveriesInitial) {
                  return Loading();
                } else if (state is CustomersWithDeliveriesLoading) {
                  return Loading();
                } else if (state is CustomersWithDeliveriesLoaded) {
                  if (state.customersWithDeliveries.length <= 0)
                    return Column(
                      children: [
                        SizedBox(height: 20),
                        Center(
                            child: Text(
                                "No customer with delivery added yet. Kindly add one.")),
                      ],
                    );
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.customersWithDeliveries.length,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ExpansionCard(
                          customerModel: state.customersWithDeliveries[index]
                              ["customer"],
                          deliveryModel: state.customersWithDeliveries[index]
                              ["delivery"],
                        );
                      },
                    ),
                  );
                } else {
                  return Loading();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            size: 30,
          ),
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage("assets/user.png"),
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }
}
