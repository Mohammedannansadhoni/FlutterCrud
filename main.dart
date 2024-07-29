import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


import 'models.dart';  // Ensure this import is here
import 'store.dart';
import 'customer_list_page.dart';
import 'add_customer_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<List<Customer>>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Customer CRUD App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CustomerListPage(),
        routes: {
          AddCustomerPage.routeName: (context) => AddCustomerPage(),
        },
      ),
    );
  }
}
