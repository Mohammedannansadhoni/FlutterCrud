import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'models.dart';  // Ensure this import is here
import 'actions.dart';
import 'add_customer_page.dart';

class CustomerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
      ),
      body: StoreConnector<List<Customer>, List<Customer>>(
        converter: (store) => store.state,
        builder: (context, customers) {
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ListTile(
                title: Text(customer.fullName),
                subtitle: Text(customer.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AddCustomerPage.routeName,
                          arguments: customer,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        StoreProvider.of<List<Customer>>(context)
                            .dispatch(DeleteCustomerAction(customer.pan));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddCustomerPage.routeName);
        },
      ),
    );
  }
}
