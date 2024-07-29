import 'package:flutter/foundation.dart';
import 'models.dart';  // Ensure this import is here

class AddCustomerAction {
  final Customer customer;

  AddCustomerAction(this.customer);
}

class DeleteCustomerAction {
  final String pan;

  DeleteCustomerAction(this.pan);
}
